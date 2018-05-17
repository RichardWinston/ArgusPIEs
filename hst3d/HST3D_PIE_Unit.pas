unit HST3D_PIE_Unit;

interface


uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls,
  ProjectPIE, ExportTemplatePIE, AnePIE, ANE_LayerUnit, HST3DUnit, CoordUnit,
  RunUnit, FunctionPIE, ImportPIE, HST3DLayerStructureUnit,
     ProgressUnit;

Type
  TPIE_Data = class(TComponent)
      HST3DForm: THST3DForm;
      ProgressForm: TProgressForm;
      RunForm: TRunForm;
      Constructor Create(AOwner: TComponent); override;
//      Destructor Destroy; override;
// a destructor is not needed; the destructor of TComponent can do the job.
  end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

// Project PIE functions and procedures.

function GDisplayNewForm (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

function GEditForm (aneHandle : ANE_PTR ;
          PIEHandle  :  ANE_PTR  ) : ANE_BOOL ; cdecl;

procedure GSaveForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ;
          rSaveInfo : ANE_STR_PTR ); cdecl;

procedure GLoadForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
          const LoadInfo : ANE_STR ); cdecl;

procedure GClearForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ); cdecl;

var

  //AString : String;
  Template : string;
  FormDataAsString : string;
  PIE_Data : TPIE_Data;


resourcestring
  DLLName = 'HST3D_GUI.dll';

implementation

uses TimeFunctionsUnit, GeologyFunctionUnit, HeatCondBoundFunctionsUnit,
     HST3DGridLayer, ANECB, HST3DVertCompLayers, MonthlyDataImportUnit,
     ParseContourUnit, MonthlyDataUnit, HST3DGeneralParameters, TimeDataUnit,
     ShowHelpUnit, HST3DGroupLayers, HST3DActiveAreaLayers,
     HST3DPermeabilityLayers, HST3DPorosityLayers, HST3DHeatCapacityLayers,
     HST3DThermCondLayers, HST3DDispersivityLayers, HST3DDistCoefLayers,
     HST3DWellLayers, HST3DRiverLayers, UtilityFunctions, WellFunctionsUnit,
     RotationCalculator, ParamNamesAndTypes, {DecoderUnit,} CreateObsGridUnit,
     PostProcessingPIEUnit, RenameUnit;

Constructor TPIE_Data.Create(AOwner: TComponent);
begin
      inherited Create(AOwner);
      HST3DForm:= THST3DForm.Create(self);
      ProgressForm:= TProgressForm.Create(self);
      RunForm:= TRunForm.Create(self);
end;
{
Destructor  TPIE_Data.Destroy;
begin
  RunForm.Free;
  ProgressForm.Free;
  HST3DForm.Free;
  inherited Destroy;
end;
}

const
  kMaxPIEDesc = 53;

var

gHST3DProjectPIEDesc : ProjectPIEDesc ;
gHST3DPIEDesc : ANEPIEDesc ;

gRunHST3DExportPIEDesc : ExportTemplatePIEDesc ;
gRunHST3DPIEDesc : ANEPIEDesc ;

gHST3D_AutotsFDesc   : FunctionPIEDesc;
gHST3D_AutotsPIEDesc : ANEPIEDesc;

gHST3D_DeltimFDesc   : FunctionPIEDesc;
gHST3D_DeltimPIEDesc : ANEPIEDesc;

gHST3D_DptasFDesc   : FunctionPIEDesc;
gHST3D_DptasPIEDesc : ANEPIEDesc;

gHST3D_DttasFDesc   : FunctionPIEDesc;
gHST3D_DttasPIEDesc : ANEPIEDesc;

gHST3D_DctasFDesc   : FunctionPIEDesc;
gHST3D_DctasPIEDesc : ANEPIEDesc;

gHST3D_DtimmnFDesc   : FunctionPIEDesc;
gHST3D_DtimmnPIEDesc : ANEPIEDesc;

gHST3D_DtimmxFDesc   : FunctionPIEDesc;
gHST3D_DtimmxPIEDesc : ANEPIEDesc;

gHST3D_TimchgFDesc   : FunctionPIEDesc;
gHST3D_TimchgPIEDesc : ANEPIEDesc;

gHST3D_MaxSolverTimesFDesc   : FunctionPIEDesc;
gHST3D_MaxSolverTimesPIEDesc : ANEPIEDesc;

gHST3D_TopFDesc   : FunctionPIEDesc;
gHST3D_TopPIEDesc : ANEPIEDesc;

gHST3D_BottomFDesc   : FunctionPIEDesc;
gHST3D_BottomPIEDesc : ANEPIEDesc;

gHST3D_CellTopFDesc   : FunctionPIEDesc;
gHST3D_CellTopPIEDesc : ANEPIEDesc;

gHST3D_CellBottomFDesc   : FunctionPIEDesc;
gHST3D_CellBottomPIEDesc : ANEPIEDesc;

gHST3D_HeatNodeLocFDesc   : FunctionPIEDesc;
gHST3D_HeatNodeLocPIEDesc : ANEPIEDesc;

gHST3D_InitHeatNodeLocFDesc   : FunctionPIEDesc;
gHST3D_InitHeatNodeLocPIEDesc : ANEPIEDesc;

gHST3D_InitHeatNodeTempFDesc   : FunctionPIEDesc;
gHST3D_InitHeatNodeTempPIEDesc : ANEPIEDesc;



gHST3D_PrislmFDesc   : FunctionPIEDesc;
gHST3D_PrislmPIEDesc : ANEPIEDesc;

gHST3D_PrikdFDesc   : FunctionPIEDesc;
gHST3D_PrikdPIEDesc : ANEPIEDesc;

gHST3D_PriptcFDesc   : FunctionPIEDesc;
gHST3D_PriptcPIEDesc : ANEPIEDesc;

gHST3D_PridvFDesc   : FunctionPIEDesc;
gHST3D_PridvPIEDesc : ANEPIEDesc;

gHST3D_PrivelFDesc   : FunctionPIEDesc;
gHST3D_PrivelPIEDesc : ANEPIEDesc;

gHST3D_PrigfbFDesc   : FunctionPIEDesc;
gHST3D_PrigfbPIEDesc : ANEPIEDesc;

gHST3D_PribcfFDesc   : FunctionPIEDesc;
gHST3D_PribcfPIEDesc : ANEPIEDesc;

gHST3D_PriwelFDesc   : FunctionPIEDesc;
gHST3D_PriwelPIEDesc : ANEPIEDesc;

gHST3D_IprptcFDesc   : FunctionPIEDesc;
gHST3D_IprptcPIEDesc : ANEPIEDesc;

gHST3D_ChkptdFDesc   : FunctionPIEDesc;
gHST3D_ChkptdPIEDesc : ANEPIEDesc;

gHST3D_PricpdFDesc   : FunctionPIEDesc;
gHST3D_PricpdPIEDesc : ANEPIEDesc;

gHST3D_SavldoFDesc   : FunctionPIEDesc;
gHST3D_SavldoPIEDesc : ANEPIEDesc;

gHST3D_CntmapFDesc   : FunctionPIEDesc;
gHST3D_CntmapPIEDesc : ANEPIEDesc;

gHST3D_VecmapFDesc   : FunctionPIEDesc;
gHST3D_VecmapPIEDesc : ANEPIEDesc;

gHST3D_PrimapFDesc   : FunctionPIEDesc;
gHST3D_PrimapPIEDesc : ANEPIEDesc;

gHST3D_GetZFDesc   : FunctionPIEDesc;
gHST3D_GetZPIEDesc : ANEPIEDesc;

gHST3D_PostImportPIEDesc : ImportPIEDesc;   // ImportPIE descriptor
gHST3D_PostPIEDesc       : ANEPIEDesc;	    // PIE descriptor

gHST3D_MonthlyImportPIEDesc : ImportPIEDesc;   // ImportPIE descriptor
gHST3D_MonthlyPIEDesc  : ANEPIEDesc;	       // PIE descriptor

gHST3D_TemporalImportPIEDesc : ImportPIEDesc;  // ImportPIE descriptor
gHST3D_TemporalPIEDesc       : ANEPIEDesc;     // PIE descriptor

gHST3D_HelpImportPIEDesc : ImportPIEDesc;      // ImportPIE descriptor
gHST3D_HelpPIEDesc       : ANEPIEDesc;	       // PIE descriptor

gHST3D_CalcCoordImportPIEDesc : ImportPIEDesc;      // ImportPIE descriptor
gHST3D_CalcCoordPIEDesc       : ANEPIEDesc;	       // PIE descriptor

// Well Functions

gHST3D_GetWellCompletionFDesc   : FunctionPIEDesc;
gHST3D_GetWellCompletionPIEDesc : ANEPIEDesc;

gHST3D_GetWellSkinFactorFDesc   : FunctionPIEDesc;
gHST3D_GetWellSkinFactorPIEDesc : ANEPIEDesc;

gHST3D_GetWellTimeFDesc   : FunctionPIEDesc;
gHST3D_GetWellTimePIEDesc : ANEPIEDesc;

gHST3D_GetWellFlowFDesc   : FunctionPIEDesc;
gHST3D_GetWellFlowPIEDesc : ANEPIEDesc;

gHST3D_GetWellSurfPresFDesc   : FunctionPIEDesc;
gHST3D_GetWellSurfPresPIEDesc : ANEPIEDesc;

gHST3D_GetWellDatumFDesc   : FunctionPIEDesc;
gHST3D_GetWellDatumPIEDesc : ANEPIEDesc;

gHST3D_GetWellTempFDesc   : FunctionPIEDesc;
gHST3D_GetWellTempPIEDesc : ANEPIEDesc;

gHST3D_GetWellMassFracFDesc   : FunctionPIEDesc;
gHST3D_GetWellMassFracPIEDesc : ANEPIEDesc;

gHST3D_GetWellTimeCountFDesc   : FunctionPIEDesc;
gHST3D_GetWellTimeCountPIEDesc : ANEPIEDesc;

gHST3D_GetWellElementCountFDesc   : FunctionPIEDesc;
gHST3D_GetWellElementCountPIEDesc : ANEPIEDesc;

gHST3D_GridImportPIEDesc : ImportPIEDesc;   // ImportPIE descriptor
gHST3D_GridPIEDesc       : ANEPIEDesc;	    // PIE descriptor

gHST3D_TimeSeriesImportPIEDesc : ImportPIEDesc;   // ImportPIE descriptor
gHST3D_TimeSeriesPIEDesc       : ANEPIEDesc;	    // PIE descriptor

gHST3D_RenameFileFDesc   : FunctionPIEDesc;
gHST3D_RenameFileDesc : ANEPIEDesc;



gPIEDesc : Array [0..kMaxPIEDesc-1] of ^ANEPIEDesc;

function GDisplayNewForm (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;
var
  layerString : ANE_STR;
  ValFileName : string;
  FormString : string;
  AStingList : TStringList;
  Index : integer;
  DirectoryName : String;
begin
  if EditWindowOpen
  then
    begin
      result := false;
    end
  else
    begin
      CoordForm := TCoordForm.Create(Application);
      PIE_Data := TPIE_Data.Create(nil);
      try
        begin
          PIE_Data.HST3DForm.CurrentModelHandle := Handle;


          // The layer structure must only be created after
          // the form has been filled with valid data
          // and HST3DForm has been assigned a non-nil value;
          With PIE_Data do
          begin
            HST3DForm.LayerStructure := THST3DLayerStructure.Create;
            if GetDllDirectory(DLLName, DirectoryName)
            then
              begin
                HST3DForm.edPath.Text := DirectoryName + '\hst3d.exe';
                HST3DForm.edBCFLOWPath.Text := DirectoryName + '\bcflow.exe';
              end
            else
              begin
                ShowMessage('File ' + DLLName + ' not found');
              end;
            // The Layer structure is free in the forms OnDestroy event handler.

            CoordForm.ShowModal;

            GetDllDirectory(DLLName, ValFileName);
            ValFileName := ValFileName + '\Hst3d';
            if HST3DForm.rgCoord.ItemIndex = 0
            then
              begin
                ValFileName := ValFileName + 'Cartesian.val';
              end
            else
              begin
                ValFileName := ValFileName + 'Cylindrical.val';
              end;
            if FileExists(ValFileName) then
            begin
               FormString := '';
               AStingList := TStringList.Create;
               try
                 begin
                   AStingList.LoadFromFile(ValFileName);
                   for Index := 0 to AStingList.Count -1 do
                   begin
                     FormString := FormString + AStingList.Strings[Index]
                       + Chr(13) + Chr(10) ;
                   end;

                   HST3DForm.Load(FormString,  HST3DForm);
    //               HST3DForm.LayerStructure.UpdateOldIndicies;
                 end
               finally
                 begin
                   AStingList.Free;
                 end;
               end;
            end;
//            HST3DForm.rgUnits.ItemIndex := CoordForm.rgUnits.ItemIndex;
            CoordForm.Free;
            CoordForm := nil;
            if HST3DForm.ShowModal = mrOK
            then
              begin
                FormDataAsString := HST3DForm.LayerStructure.WriteLayers(Handle);
                layerString := PChar(FormDataAsString);

                rPIEHandle^ := PIE_Data;
        //        rPIEHandle := @PIE_Data;

                rLayerTemplate^ := layerString;
                HST3DForm.LayerStructure.SetStatus(sNormal);
                result := True;
              end
            else
              begin
                result := False;
                PIE_Data.Free;
                PIE_Data := nil;
              end;
          end;

        end
      Except on Exception do
        begin
          CoordForm.Free;
          PIE_Data.Free;
          PIE_Data := nil;
          result := False;
        end;
      end;
    end;
end; { GDisplayNewForm }


function GEditForm (aneHandle : ANE_PTR ;
          PIEHandle  :  ANE_PTR  ) : ANE_BOOL ; cdecl;
begin
  if EditWindowOpen
  then
    begin
      result := False;
    end
  else
    begin
      EditWindowOpen := True;
      try
        begin
          try
            begin
              PIE_Data := PIEHandle;
              PIE_Data.HST3DForm.CurrentModelHandle := aneHandle ;
              With PIE_Data do
              begin
//                HST3DForm.PageControl1.ActivePage := HST3DForm.tabProject;
                FormDataAsString := HST3DForm.FormToString(HST3DForm);
                if HST3DForm.ShowModal = mrOK
                then
                  begin
                    Screen.Cursor := crHourGlass;
                    HST3DForm.LayerStructure.OK(PIE_Data.HST3DForm.CurrentModelHandle);
                    Screen.Cursor := crDefault;
                    result := True;
                  end
                else
                  begin
                    Screen.Cursor := crHourGlass;
                    HST3DForm.LayerStructure.Cancel;
                    HST3DForm.StringToForm(FormDataAsString, HST3DForm);
                    HST3DForm.LayerStructure.SetStatus(sNormal);
                    Screen.Cursor := crDefault;
                    result := False;
                  end;
              end;
            end;
          except on Exception do
            begin
                result := False;
            end;
          end
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end;
    end;

end; { GEditForm }

procedure GSaveForm(aneHandle : ANE_PTR ; PIEHandle : ANE_PTR ;
   rSaveInfo : ANE_STR_PTR ); cdecl;
var
  AnANE_STR : ANE_STR;
begin
//  CurrentModelHandle := aneHandle;
  PIE_Data := PIEHandle;
  PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
  With PIE_Data do
  begin
    // read the data on HST3DForm to a string
    FormDataAsString := HST3DForm.FormToString(HST3DForm);
  end;
  AnANE_STR := PChar(FormDataAsString);
  rSaveInfo^ := AnANE_STR;
end;

procedure GLoadForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
  const LoadInfo : ANE_STR ); cdecl;
const
  kMisspelledVertComp = 'Vertical Compressibilty Unit';
  kInvalidGridVertComp : string = 'Vertical Compressibilty Unit';
  kMisspelledGridActive : string = 'Active Cell Unit';
  kMisspelledGridXCond : string = 'X Conductivity Unit';
  kMisspelledGridYCond : string = 'Y Conductivity Unit';
  kMisspelledGridZCond : string = 'Z Conductivity Unit';
  kMisspelledGridVertComp : string = 'Vertical Compr Unit';
  kMisspelledGridHeat : string = 'Heat Capacity Unit';
  kMisspelledGridLongDisp : string = 'Longitudinal Dispersivity Unit';
  kMisspelledGridLongDisp2 : string = 'Lonitudinal Dispersivity Unit';
  kMisspelledGridTransDisp : string = 'Transverse Dispersivity Unit';
  kMisspelledGridDist : string = 'Distribution Coefficient Unit';
  kMisspelledGridKx : string = 'Kx Unit';
  kMisspelledGridKy : string = 'Ky Unit';
  kMisspelledGridKz : string = 'Kz Unit';
  kMisspelledGridPor : string = 'Porosity Unit';

  kMisspelledUnitGroupLayer = 'Unit';
  kMisspelledActiveAreaUnit = 'Active Area Unit';
  kMisspelledPermUnit = 'Permeability Unit';
  kMisspelledPorosityUnit = 'Porosity Unit';
  kMisspelledHeatCap : string = 'Heat Capacity Unit';
  kMisspelledThermLayer : string = 'Thermal Conductivity Unit';
  kMisspelledDispLayer : string = 'Dispersivity Unit';
  KMisspelledDistCoef : string = 'Distribution Coefficient Unit';
  kMisspelledVertComp2 = 'Vertical Compressibility Unit';

  kMisspelledWellCompl : string = 'Well Completion Unit';
  kMisspelledWellSkin : string = 'Well Skin Factor Unit';

  kMisspelledRivLayer : string = 'River';
var
  UnitIndex : Integer;
  LayerHandle : ANE_PTR;
  OldName, NewName, NewExpression : string;
  parameterIndex : ANE_Int32;
  Renamed : boolean;
  NLIndex : integer;
  AnHST3DGridLayer : THST3DGridLayer;
  AGridNLParameters : TGridNLParameters ;
  ALayerElevationParameter : TLayerElevationParameter;
  ParameterName : string;
  ParameterTemplate : string;
  parameterCount : ANE_INT32;
  AT0Parameter : TT0Parameter;
  AW0Parameter : TW0Parameter;
{  ObsElevLayer : TObsElevLayer;
  HST3DNodeGridLayer : THST3DNodeGridLayer;
  layerTemplate : string;
  ANE_layerTemplate : ANE_STR; }

begin
//  CurrentModelHandle := aneHandle;

      PIE_Data := TPIE_Data.Create(nil);
      PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
{  HST3DForm := THST3DForm.Create(Application);
      RunForm := TRunForm.Create(Application);
      ProgressForm := TProgressForm.Create(Application);  }
  rPIEHandle^ := PIE_Data;
// The layer structure must only be created after the
// form has been filled with valid data
// and HST3DForm has been assigned a non-nil value;
  With PIE_Data do
  begin
    // the layer structure is freed in the OnDestroy event handler of the form.
    HST3DForm.LayerStructure := THST3DLayerStructure.Create;

    HST3DForm.LayerStructure.SetStatus(sNormal);

    // read the data in a string passed by Argus ONE to HST3DForm.
    HST3DForm.Load(String(LoadInfo), HST3DForm);

    HST3DForm.LayerStructure.FreeByStatus(sDeleted);
    HST3DForm.LayerStructure.SetStatus(sNormal);
    HST3DForm.LayerStructure.UpdateIndicies;
    HST3DForm.LayerStructure.UpdateOldIndicies;
    Renamed := False;

{
    LayerHandle := ANE_LayerGetHandleByName
      (aneHandle, PChar(THST3DNodeGridLayer.ANE_Name) );
    if (LayerHandle = nil) then
    begin
        LayerHandle := ANE_LayerGetHandleByName
          (aneHandle, PChar(THST3DGridLayer.ANE_Name) );


        HST3DNodeGridLayer := PIE_Data.HST3DForm.LayerStructure.
          UnIndexedLayers.GetLayerByName(THST3DNodeGridLayer.ANE_Name)
          as THST3DNodeGridLayer;

        layerTemplate := HST3DNodeGridLayer.WriteLayer;
        ANE_layerTemplate := PChar(layerTemplate);

        ANE_LayerAddByTemplate(aneHandle, ANE_layerTemplate,
          nil )
    end;

    LayerHandle := ANE_LayerGetHandleByName
      (aneHandle, PChar(TObsElevLayer.ANE_Name) );
    if (LayerHandle = nil) then
    begin
        LayerHandle := ANE_LayerGetHandleByName
          (aneHandle, PChar(TUnindexedGroupLayer.ANE_Name) );


        ObsElevLayer := PIE_Data.HST3DForm.LayerStructure.
          UnIndexedLayers.GetLayerByName(TObsElevLayer.ANE_Name)
          as TObsElevLayer;

        layerTemplate := ObsElevLayer.WriteLayer;
        ANE_layerTemplate := PChar(layerTemplate);

        ANE_LayerAddByTemplate(aneHandle, ANE_layerTemplate,
          LayerHandle )
    end;
}

    LayerHandle := ANE_LayerGetHandleByName
      (aneHandle, PChar(kMisspelledRivLayer) );
    if not (LayerHandle = nil) then
    begin
        NewName := kRivLayer;
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName));
    end;

    LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(kWellLayerName) );
    if not (LayerHandle = nil) then
    begin
      for UnitIndex := 1 to StrToInt(HST3DForm.edNumLayers.Text) do
      begin
        OldName := kMisspelledWellCompl + IntToStr(UnitIndex);
        NewName := kWellCompl + IntToStr(UnitIndex);
        parameterIndex := ANE_LayerGetParameterByName(aneHandle,
           layerHandle, PChar(OldName) );
        if not (parameterIndex = -1) then
          begin
            ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
              PChar(NewName));
          end;

        OldName := kMisspelledWellSkin + IntToStr(UnitIndex);
        NewName := kWellSkin + IntToStr(UnitIndex);
        parameterIndex := ANE_LayerGetParameterByName(aneHandle,
           layerHandle, PChar(OldName) );
        if not (parameterIndex = -1) then
          begin
            ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
              PChar(NewName));
          end;
      end;
    end;

    for UnitIndex := 1 to StrToInt(HST3DForm.edNumLayers.Text) do
    begin
      OldName := kMisspelledVertComp + IntToStr(UnitIndex);
      NewName := kVertComp + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
        parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
           end;
      end;

      OldName := kMisspelledUnitGroupLayer + IntToStr(UnitIndex);
      NewName := kUnitGroupLayer + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
      end;

      OldName := kMisspelledActiveAreaUnit + IntToStr(UnitIndex);
      NewName := kActiveAreaUnit + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
        parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
           end;
      end;

      OldName := kMisspelledPermUnit + IntToStr(UnitIndex);
      NewName := kPermUnit + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
      end;

      OldName := kMisspelledPorosityUnit + IntToStr(UnitIndex);
      NewName := kPorosityUnit + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
        parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
           end;
      end;

      OldName := kMisspelledHeatCap + IntToStr(UnitIndex);
      NewName := kHeatCap + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
        parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
           end;
      end;

      OldName := kMisspelledThermLayer + IntToStr(UnitIndex);
      NewName := kThermLayer + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
      end;

      OldName := kMisspelledDispLayer + IntToStr(UnitIndex);
      NewName := kDispLayer + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
      end;

      OldName := KMisspelledDistCoef + IntToStr(UnitIndex);
      NewName := KDistCoef + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
        parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
           end;
      end;

      OldName := kMisspelledVertComp2 + IntToStr(UnitIndex);
      NewName := kVertComp + IntToStr(UnitIndex);
      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldName) );
      if not (LayerHandle = nil) then
      begin
        ANE_LayerRename(aneHandle, layerHandle, PChar(NewName) );
        Renamed := True;
        parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
           end;
      end;



      LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(kGridLayer) );


      OldName := kInvalidGridVertComp + IntToStr(UnitIndex);
      NewName := kGridVertComp + IntToStr(UnitIndex);
      NewExpression := kVertComp + IntToStr(UnitIndex);
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridActive + IntToStr(UnitIndex);
      NewName := kGridActive + IntToStr(UnitIndex);
      NewExpression := 'If(IsNA(DefaultValue(' + kActiveAreaUnit
        + IntToStr(UnitIndex)  + ')), (BlockIsActive()&('
        + kActiveAreaUnit + IntToStr(UnitIndex)  + '!=0)&(IsNA('
        + kActiveAreaUnit + IntToStr(UnitIndex)  + '))), (BlockIsActive()&('
        + kActiveAreaUnit + IntToStr(UnitIndex)  + ')))';
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridXCond + IntToStr(UnitIndex);
      NewName := kGridXCond + IntToStr(UnitIndex);
      NewExpression := kThermLayer + IntToStr(UnitIndex) + '.' + kThermX;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridYCond + IntToStr(UnitIndex);
      NewName := kGridYCond + IntToStr(UnitIndex);
      NewExpression := kThermLayer + IntToStr(UnitIndex) + '.' + kThermY;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridZCond + IntToStr(UnitIndex);
      NewName := kGridZCond + IntToStr(UnitIndex);
      NewExpression := kThermLayer + IntToStr(UnitIndex) + '.' + kThermZ;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridVertComp + IntToStr(UnitIndex);
      NewName := kGridVertComp + IntToStr(UnitIndex);
      NewExpression := kVertComp + IntToStr(UnitIndex);
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridHeat + IntToStr(UnitIndex);
      NewName := kGridHeat + IntToStr(UnitIndex);
      NewExpression := kHeatCap + IntToStr(UnitIndex);
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridLongDisp + IntToStr(UnitIndex);
      NewName := kGridLongDisp + IntToStr(UnitIndex);
      NewExpression := kDispLayer + IntToStr(UnitIndex) + '.' + kDispLong;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridLongDisp2 + IntToStr(UnitIndex);
      NewName := kGridLongDisp + IntToStr(UnitIndex);
      NewExpression := kDispLayer + IntToStr(UnitIndex) + '.' + kDispLong;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridTransDisp + IntToStr(UnitIndex);
      NewName := kGridTransDisp + IntToStr(UnitIndex);
      NewExpression := kDispLayer + IntToStr(UnitIndex) + '.' + kDispTrans;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridDist + IntToStr(UnitIndex);
      NewName := kGridDist + IntToStr(UnitIndex);
      NewExpression := KDistCoef + IntToStr(UnitIndex);
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridKx + IntToStr(UnitIndex);
      NewName := kGridKx + IntToStr(UnitIndex);
      NewExpression := kPermUnit + IntToStr(UnitIndex) + '.' + kPermKx;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridKy + IntToStr(UnitIndex);
      NewName := kGridKy + IntToStr(UnitIndex);
      NewExpression := kPermUnit + IntToStr(UnitIndex) + '.' + kPermKy;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridKz + IntToStr(UnitIndex);
      NewName := kGridKz + IntToStr(UnitIndex);
      NewExpression := kPermUnit + IntToStr(UnitIndex) + '.' + kPermKz;
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

      OldName := kMisspelledGridPor + IntToStr(UnitIndex);
      NewName := kGridPor + IntToStr(UnitIndex);
      NewExpression := kPorosityUnit + IntToStr(UnitIndex);
      if not (LayerHandle = nil) then
      begin
         parameterIndex := ANE_LayerGetParameterByName(aneHandle,
         layerHandle, PChar(OldName) );
         if not (parameterIndex = -1) then
           begin
             ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
               PChar(NewName));
             ANE_LayerSetParameterExpression(aneHandle, layerHandle,
               parameterIndex, PChar(NewExpression) ) ;
             Renamed := True;
           end;
      end;

    end;

    LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(kGridLayer) );
    AnHST3DGridLayer := HST3DForm.LayerStructure.UnIndexedLayers.GetLayerByName
      (kGridLayer) as THST3DGridLayer;

    AT0Parameter := AnHST3DGridLayer.ParamList.GetParameterByName(kT0)
      as TT0Parameter;
    ParameterName := AT0Parameter.WriteName;
    parameterIndex := ANE_LayerGetParameterByName(aneHandle,
          layerHandle, PChar(ParameterName) );
    if (parameterIndex = -1) then
    begin
      ParameterTemplate := AT0Parameter.WritePar(aneHandle);
      ANE_LayerAddParametersByTemplate(aneHandle,
        LayerHandle, PChar(ParameterTemplate), -1 );
    end;

    AW0Parameter := AnHST3DGridLayer.ParamList.GetParameterByName(kW0)
      as TW0Parameter;
    ParameterName := AW0Parameter.WriteName;
    parameterIndex := ANE_LayerGetParameterByName(aneHandle,
          layerHandle, PChar(ParameterName) );
    if (parameterIndex = -1) then
    begin
      ParameterTemplate := AW0Parameter.WritePar(aneHandle);
      ANE_LayerAddParametersByTemplate(aneHandle,
        LayerHandle, PChar(ParameterTemplate), -1 );
    end;

    For NLIndex := 0 to AnHST3DGridLayer.IndexedParamList2.Count -1 do
    begin
       AGridNLParameters := AnHST3DGridLayer.IndexedParamList2.Items[NLIndex]
         as TGridNLParameters;
       ALayerElevationParameter
         := AGridNLParameters.GetParameterByName(kElevation)
         as TLayerElevationParameter;
       ParameterName := ALayerElevationParameter.WriteName
         + ALayerElevationParameter.WriteIndex;
       parameterIndex := ANE_LayerGetParameterByName(aneHandle,
          layerHandle, PChar(ParameterName) );
      if (parameterIndex = -1) then
      begin
        ParameterTemplate := ALayerElevationParameter.WritePar(aneHandle);

        parameterCount := ANE_LayerGetNumParameters(aneHandle, LayerHandle,
                       kPIEGridLayerSubParam ) +
             ANE_LayerGetNumParameters(aneHandle, LayerHandle,
                       kPIEBlockSubParam );

        ANE_LayerAddParametersByTemplate(aneHandle,
          LayerHandle, PChar(ParameterTemplate),
          parameterCount-1 );
      end;
    end;


    if Renamed then
    begin
      ANE_MakeDirty(aneHandle);
    end;
  end;
end;

procedure GClearForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ); cdecl;
begin

//    CurrentModelHandle := aneHandle;
    PIE_Data := PIEHandle;
    PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
//  PIE_Data.HST3DForm.CurrentModelHandle := nil;
    PIE_Data.Free;

{    HST3DForm.Free;  // free up memory associated with HST3DForm.
    RunForm.Free;
    ProgressForm.Free;  }
//    LayerStructure := nil;

end; { GClearForm }

procedure RunHST3DPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;
var
//  Demo : Boolean;
  Result : ANE_STR;
  Path, DirectoryName : String;
//  layerHandle : ANE_PTR ;
//  NumRows : integer;
//  NumColumns : integer;

begin
  Result := nil;

      if EditWindowOpen
      then
        begin
          result := nil;
        end  // if EditWindowOpen
      else
        begin
          EditWindowOpen := True;
          try  // # 2
            begin
              Try // # 1
                begin
            //      CurrentModelHandle := aneHandle;
                  Result := nil;
                  ANE_GetPIEProjectHandle(aneHandle, @PIE_Data );
                  PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
                  With PIE_Data do
                  begin
{                    Demo := False;
//                    Demo := not HST3DForm.IsRegistered;
                    if Demo then
                    begin
                      layerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(kGridLayer) ) ;

                      ANE_EvaluateStringAtLayer(aneHandle, layerHandle ,
                               kPIEInteger, 'NumRows()', @NumRows );
                      ANE_EvaluateStringAtLayer(aneHandle, layerHandle,
                          kPIEInteger, 'NumColumns()', @NumColumns);
                    end; // if Demo    }
{                    if Demo and ((NumRows > 20) or (NumColumns > 20))
                    then
                      begin
                        ShowMessage('The demo version can only run models with 20 or fewer rows and columns.');
                      end
                    else // if Demo and ((NumRows > 20) or (NumColumns > 20))
                      begin  }
                        if RunForm.ShowModal = mrOK then
                        begin
                            RunForm.Cursor := crHourGlass;
                            GetDllDirectory(DLLName, DirectoryName);
                            Path := DirectoryName;
                            if RunForm.rgRunChoice.ItemIndex < 2
                            then
                              begin
{                                if RunForm.cbUseUnencrypted.Checked
                                then
                                  begin
                                    Path := Path + '\Unencodedhst3d.met' ;
                                  end
                                else
                                  begin  }
                                    Path := Path + '\hst3d.met' ;
//                                  end;
                                // Allows programmer to have met file in a location different
                                // from the users' location.
                                if FileExists(Path)
                                then
                                  begin
                                    RunForm.ExportTemplate.LoadFromFile(Path);
{                                    if not RunForm.cbUseUnencrypted.Checked then
                                      begin
                                        Decrypt(RunForm.ExportTemplate);
                                      end; }
                                  end
                                else
                                  begin
                                    ShowMessage('Unable to load hst3d.met');
                                  end; //  if FileExists(Path)
                              end // if RunForm.rgRunChoice.ItemIndex < 2
                            else // if RunForm.rgRunChoice.ItemIndex < 2
                              begin
{                                if RunForm.cbUseUnencrypted.Checked
                                then
                                  begin
                                    Path := Path + '\Unencodedbcflow.met';
                                  end
                                else
                                  begin }
                                    Path := Path + '\bcflow.met';
//                                  end;
                                // Allows programmer to have met file in a location different
                                // from the users' location.
                                if FileExists(Path )
                                then
                                  begin
                                    RunForm.ExportTemplate.LoadFromFile(Path );
{                                    if not RunForm.cbUseUnencrypted.Checked then
                                      begin
                                        Decrypt(RunForm.ExportTemplate);
                                      end; }
                                  end
                                else
                                  begin
                                    ShowMessage('Unable to load bcflow.met');
                                  end; // if FileExists(Path ) else
                              end; // if RunForm.rgRunChoice.ItemIndex < 2 else
                            Template := HST3DForm.ReplaceValues(HST3DForm,
                              RunForm.ExportTemplate);

                            Path := DirectoryName + '\LastTemplate.met';
                            RunForm.ExportTemplate.SaveToFile(Path);
{                            if PIE_Data.HST3DForm.IsRegistered
                              and (PIE_Data.HST3DForm.raRegister.User = 'Richard B. Winston') then
                            begin
                              RunForm.ExportTemplate.SaveToFile(DirectoryName + '\last.met');
                            end; }
                            Result := PChar(Template);
                        end; // if RunForm.ShowModal = mrOK then
//                      end; // // if Demo and ((NumRows > 20) or (NumColumns > 20))
                  end; // With PIE_Data do

                end // Try # 1
              except on Exception do
                begin
                  Result := nil;
                end;
              end; // Try # 1
            end;
          finally
            begin
              EditWindowOpen := False;
            end;
          end; // Try # 2
        end; // if EditWindowOpen else
  returnTemplate^ := Result;
end;

function GMonthlyDataPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR) : ANE_BOOL; cdecl;
var
  AContourList : TContourList;
  AnAnnualDataList : TAnnualDataList;
  ContourIndex : integer;
  ValueIndex : integer;
  AContour : TContour;
  AMonth : TMonth;
  AnAnnualData : TAnnualData;
  AnnualDataIndex, TimeDataIndex : integer;
  ParamIndex : integer;
  ParamName : string;
  TextToImport : string;
  Time : double ;
  TimePerDay : double;
  ParamNameToResetToNA : string;
  ResetIndex : integer;
begin
  if EditWindowOpen
  then
    begin
      result := False;
    end
  else
    begin
      EditWindowOpen := True;
      result := True;
      try
        begin
          try // 1
            begin
        //      CurrentModelHandle := aneHandle;
              ANE_GetPIEProjectHandle(aneHandle, @PIE_Data );
              PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
              frmImport := TfrmImport.Create(application);
              try // 2
                begin
                  if readParameters(LayerHandle )
                  then
                    begin
                      if frmImport.ShowModal = mrOK then
                      begin
                        if frmImport.rgItems.ItemIndex > -1
                        then
                          begin
                            ParamName := frmImport.rgItems.Items
                              [frmImport.rgItems.ItemIndex];
                            AContourList := TContourList.Create;
                            try  // 3
                              begin
                                AContourList.ReadContourFromClipboard;
                                if AContourList.Count > 0
                                then
                                  begin
                                    AnAnnualDataList := TAnnualDataList.Create;
                                    try // 4
                                      begin
                                        try
                                          begin
                                            AnAnnualDataList.ReadFromFile
                                              (frmImport.dlgOpenImport.FileName);
                                          end
                                        Except
                                          on Exception do
                                          begin
                                            ShowMessage('Improperly formatted '
                                              + 'Monthly data file');
                                            raise
                                          end;
                                        end;
                                        if not (AnAnnualDataList.Count * 12 >
                                          StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text))
                                        then
                                          begin
                                            for ContourIndex := 0 to
                                              AContourList.Count -1 do
                                            begin
                                              ValueIndex := 0;
                                              Time := 0;
                                              AContour := AContourList.Contours[ContourIndex];
                                              for AnnualDataIndex := 0 to AnAnnualDataList.Count -1 do
                                              begin
                                                AnAnnualData := AnAnnualDataList.AnnualData[AnnualDataIndex];
                                                for AMonth := mJan to mDec do
                                                begin
                                                  Inc(ValueIndex);

                                                  for ResetIndex := 0 to frmImport.clbReset.Items.Count -1 do
//                                                  for ResetIndex := 0 to frmImport.RzclReset.Items.Count -1 do
                                                  begin
                                                    if frmImport.clbReset.State[ResetIndex] = cbChecked then
//                                                    if frmImport.RzclReset.ItemState[ResetIndex] = cbChecked then
                                                    begin
                                                      ParamNameToResetToNA := frmImport.clbReset.Items[ResetIndex];
//                                                      ParamNameToResetToNA := frmImport.RzclReset.Items[ResetIndex];
                                                      ParamIndex := ANE_LayerGetParameterByName(aneHandle ,
                                                                 layerHandle, PChar(ParamNameToResetToNA + IntToStr(ValueIndex) ));
                                                      if (ParamIndex < 0) or (ValueIndex > StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text))
                                                      Then showMessage('Error');
                                                      AContour.Values[ParamIndex] := '$N/A';
                                                    end;

                                                  end;

                                                  ParamIndex := ANE_LayerGetParameterByName(aneHandle ,
                                                             layerHandle, PChar(ParamName + IntToStr(ValueIndex) ));
                                                  if (ParamIndex < 0) or (ValueIndex > StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text))
                                                  Then showMessage('Error');
                                                  AContour.Values[ParamIndex] := FloatToStr(AnAnnualData.MonthlyData[AMonth]);
                                                  ParamIndex := ANE_LayerGetParameterByName(aneHandle ,
                                                             layerHandle, PChar(kGenParTime + IntToStr(ValueIndex) ));
                                                  AContour.Values[ParamIndex] := FloatToStr(Time);
                                                  TimePerDay := 1;
                                                  case PIE_Data.HST3DForm.rgTimeUnits.ItemIndex of
                                                    0:  // seconds
                                                      begin
                                                        TimePerDay := 3600*24;
                                                      end;
                                                    1:  // minutes
                                                      begin
                                                        TimePerDay := 60*24;
                                                      end;
                                                    2: // hours
                                                      begin
                                                        TimePerDay := 24;
                                                      end;
                                                    3: // days
                                                      begin
                                                        TimePerDay := 1;
                                                      end;
                                                    4: // years
                                                      begin
                                                        TimePerDay := 1/AnAnnualData.DaysPerYear;
                                                      end;
                                                  end; //  case PIE_Data.HST3DForm.rgTimeUnits.ItemIndex of
                                                  Time := Time + AnAnnualData.DaysPerMonth(AMonth)*TimePerDay;
        //                                          AContour.Values[ParamIndex] := FloatToStr(Time);
                                                end; // for AMonth := mJan to mDec do
                                              end; // for AnnualDataIndex := 0 to AnAnnualDataList.Count -1 do
                                              for TimeDataIndex := AnAnnualDataList.Count * 12 to StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text) -1 do
                                              begin
                                                ParamIndex := ANE_LayerGetParameterByName(aneHandle ,
                                                   layerHandle, PChar(kGenParTime + IntToStr(TimeDataIndex + 1) ));
                                                AContour.Values[ParamIndex] := '$N/A';
                                              end; // for TimeDataIndex := ATimeDataList.Count to StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text) do
                                            end;  // for ContourIndex := 0 to AContourList.Count -1 do
                                            TextToImport := AContourList.WriteContourString ;
                                            ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, PChar( TextToImport));
                                          end  // if (AnAnnualDataList.Count * 12 > StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text))
                                        else
                                          begin
                                            ShowMessage('The current number of time periods'
                                               + ' in the model is too small. '
                                               + 'Open "PIEs|Edit Project Info...", '
                                               + 'change to the "Time" tab and increase the '
                                               + 'number of time periods to at least '
                                               + IntToStr(AnAnnualDataList.Count * 12) + '.');
                                            result := False;
                                          end; // if (AnAnnualDataList.Count * 12 > StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text)) else
                                      end;
                                    finally
                                      begin
                                        AnAnnualDataList.Free;
                                      end;
                                    end;  // try 4
                                  end // if AContourList.Count > 0
                                else
                                  begin
                                    ShowMessage('Unable to read contours from clipboard');
                                    result := False;
                                  end; // if AContourList.Count > 0 else
                              end
                            finally
                              begin
                                AContourList.Free;
                              end;
                            end; // try 3
                          end // if frmImport.rgItems.ItemIndex > -1
                        else
                          begin
                                ShowMessage('No Data set selected.');
                                result := False;
                          end; // if frmImport.rgItems.ItemIndex > -1 else
                      end; // if frmImport.ShowModal = mrOK then
                    end; // if readParameters(LayerHandle )
                end;
              finally
                begin
                  frmImport.Free;
                end;
              end; // try 2
            end;
          except on Exception do
            begin
              ShowMessage('Internal error in Monthly Data PIE');
              result := False;
            end;
          end;  // try 1
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end;
    end;

end;

function GTemporalDataPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR): ANE_BOOL; cdecl;
var
  AContourList : TContourList;
  ATimeData : TTimeData;
  ContourIndex : integer;
  AContour : TContour;
  ATimeDataList : TTimeDataList;
  TimeDataIndex : integer;
  ParamIndex : integer;
  ParamName : string;
  TextToImport : string;
//  Time : double ;
  ParamNameToResetToNA : string;
  ResetIndex : integer;
begin
  result := True;
  if EditWindowOpen
  then
    begin
      result := False;
    end
  else
    begin
      EditWindowOpen := True;
      try
        begin
          try // 1
            begin
        //      CurrentModelHandle := aneHandle;
              ANE_GetPIEProjectHandle(aneHandle, @PIE_Data );
              PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
              frmImport := TfrmImport.Create(application);
              try // 2
                begin
                  if readParameters(LayerHandle )
                  then
                    begin
                      if frmImport.ShowModal = mrOK then
                      begin
                        if frmImport.rgItems.ItemIndex > -1
                        then
                          begin
                            ParamName := frmImport.rgItems.Items
                              [frmImport.rgItems.ItemIndex];
                            AContourList := TContourList.Create;
                            try  // 3
                              begin
                                AContourList.ReadContourFromClipboard;
                                if AContourList.Count > 0
                                then
                                  begin
                                    ATimeDataList := TTimeDataList.Create;
                                    try // 4
                                      begin
                                        ATimeDataList.ReadFromFile
                                          (frmImport.dlgOpenImport.FileName);
                                        if not (ATimeDataList.Count  >
                                          StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text))
                                        then
                                          begin
                                            for ContourIndex := 0 to AContourList.Count -1 do
                                            begin
        //                                      ValueIndex := 0;
//                                              Time := 0;
                                              AContour := AContourList.Contours[ContourIndex];
                                              for TimeDataIndex := 0 to ATimeDataList.Count -1 do
                                              begin

                                                  for ResetIndex := 0 to frmImport.clbReset.Items.Count -1 do
//                                                  for ResetIndex := 0 to frmImport.RzclReset.Items.Count -1 do
                                                  begin
                                                    if frmImport.clbReset.State[ResetIndex] = cbChecked then
//                                                    if frmImport.RzclReset.ItemState[ResetIndex] = cbChecked then
                                                    begin
                                                      ParamNameToResetToNA := frmImport.clbReset.Items[ResetIndex];
//                                                      ParamNameToResetToNA := frmImport.RzclReset.Items[ResetIndex];
                                                      ParamIndex := ANE_LayerGetParameterByName(aneHandle ,
                                                                 layerHandle, PChar(ParamNameToResetToNA + IntToStr(TimeDataIndex) ));
                                                      if (ParamIndex < 0) or (TimeDataIndex > StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text))
                                                      Then showMessage('Error');
                                                      AContour.Values[ParamIndex] := '$N/A';
                                                    end;

                                                  end;

                                                ATimeData := ATimeDataList.Items[TimeDataIndex];
                                                ParamIndex := ANE_LayerGetParameterByName(aneHandle ,
                                                             layerHandle, PChar(ParamName + IntToStr(TimeDataIndex + 1) ));
                                                if (ParamIndex < 0) or (TimeDataIndex + 1 >
                                                  StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text))
                                                Then
                                                begin
                                                  showMessage('Error');
                                                  result := False;
                                                end;
                                                AContour.Values[ParamIndex] := FloatToStr(ATimeData.Datum);
                                                ParamIndex := ANE_LayerGetParameterByName(aneHandle ,
                                                   layerHandle, PChar(kGenParTime + IntToStr(TimeDataIndex + 1) ));
                                                AContour.Values[ParamIndex] := FloatToStr(ATimeData.Time);
//                                                Time := Time + ATimeData.Time;

                                              end; // for AnnualDataIndex := 0 to AnAnnualDataList.Count -1 do
                                              for TimeDataIndex := ATimeDataList.Count to StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text) -1 do
                                              begin
                                                ParamIndex := ANE_LayerGetParameterByName(aneHandle ,
                                                   layerHandle, PChar(kGenParTime + IntToStr(TimeDataIndex + 1) ));
                                                AContour.Values[ParamIndex] := '$N/A';
                                              end; // for TimeDataIndex := ATimeDataList.Count to StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text) do
                                            end;  // for ContourIndex := 0 to AContourList.Count -1 do
                                            TextToImport := AContourList.WriteContourString ;
                                            ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, PChar( TextToImport));
                                          end  // if (AnAnnualDataList.Count * 12 > StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text))
                                        else
                                          begin
                                            ShowMessage('The current number of time periods'
                                              + ' in the model is too small. '
                                              + 'Open "PIEs|Edit Project Info...", '
                                              + 'change to the "Time" tab and increase the '
                                              + 'number of time periods to at least '
                                              + IntToStr(ATimeDataList.Count ) + '.');
                                            result := False;
                                          end; // if (AnAnnualDataList.Count * 12 > StrToInt(PIE_Data.HST3DForm.edMaxTimes.Text)) else
                                      end;
                                    finally
                                      begin
                                        ATimeDataList.Free;
                                      end;
                                    end;  // try 4
                                  end // if AContourList.Count > 0
                                else
                                  begin
                                    ShowMessage('Unable to read contours from clipboard');
                                    result := False;
                                  end; // if AContourList.Count > 0 else
                              end
                            finally
                              begin
                                AContourList.Free;
                              end;
                            end; // try 3
                          end // if frmImport.rgItems.ItemIndex > -1
                        else
                          begin
                                ShowMessage('No Data set selected.');
                                result := False;
                          end; // if frmImport.rgItems.ItemIndex > -1 else
                      end; // if frmImport.ShowModal = mrOK then
                    end; // if readParameters(LayerHandle )
                end;
              finally
                begin
                  frmImport.Free;
                end;
              end; // try 2
            end;
          except on Exception do
            begin
              ShowMessage('Internal error in Temporal Data PIE');
              result := False;
            end;
          end;  // try 1
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end;
    end;

end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
Const
  ProjectName : ANE_STR = 'Argus HST3D';
var
  CurrentFunctionFlags : EFunctionPIEFlags;
begin
        CurrentFunctionFlags := (kFunctionNeedsProject or kFunctionIsHidden) ;
//        CurrentFunctionFlags := 0 ;
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;

        // Project PIE descriptor - New HST3D Project
	gHST3DProjectPIEDesc.version := PROJECT_PIE_VERSION;
	gHST3DProjectPIEDesc.name := ProjectName;
	gHST3DProjectPIEDesc.projectFlags := kProjectCanEdit or
                                            kProjectShouldClean or
//                                            kCallEditAfterNewProject or
                                            kProjectShouldSave;
	gHST3DProjectPIEDesc.createNewProc := GDisplayNewForm;
	gHST3DProjectPIEDesc.editProjectProc := GEditForm;
	gHST3DProjectPIEDesc.cleanProjectProc := GClearForm;
	gHST3DProjectPIEDesc.saveProc := GSaveForm;
	gHST3DProjectPIEDesc.loadProc := GLoadForm;

        // PIE descriptor - New HST3D Project
	gHST3DPIEDesc.name  := 'New HST3D Project';
	gHST3DPIEDesc.PieType :=  kProjectPIE;
	gHST3DPIEDesc.descriptor := @gHST3DProjectPIEDesc;

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gHST3DPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gRunHST3DExportPIEDesc.name := 'Run HST3D';
	gRunHST3DExportPIEDesc.exportType := kPIEGridLayer;
	gRunHST3DExportPIEDesc.exportFlags := kExportNeedsProject or kExportDontShowParamDialog;
	gRunHST3DExportPIEDesc.getTemplateProc := RunHST3DPIE;
	gRunHST3DExportPIEDesc.neededProject := ProjectName;

	gRunHST3DPIEDesc.name  := 'Run HST3D';
	gRunHST3DPIEDesc.PieType :=  kExportTemplatePIE;
	gRunHST3DPIEDesc.descriptor := @gRunHST3DExportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gRunHST3DPIEDesc;
        Inc(numNames);	// add descriptor to list

	gHST3D_AutotsFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_AutotsFDesc.name := 'HST3D_Autots';	        // name of function
	gHST3D_AutotsFDesc.address := GHST3D_AutotsMMFun;		// function address
	gHST3D_AutotsFDesc.returnType := kPIEBoolean;		// return value type
	gHST3D_AutotsFDesc.numParams :=  1;			// number of parameters
	gHST3D_AutotsFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_AutotsFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_AutotsFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_AutotsFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_AutotsFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_AutotsPIEDesc.name  := 'HST3D_Autots';		// name of PIE
	gHST3D_AutotsPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_AutotsPIEDesc.descriptor := @gHST3D_AutotsFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_AutotsPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_DeltimFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_DeltimFDesc.name := 'HST3D_Deltim';	        // name of function
	gHST3D_DeltimFDesc.address := GHST3D_DeltimMMFun;		// function address
	gHST3D_DeltimFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_DeltimFDesc.numParams :=  1;			// number of parameters
	gHST3D_DeltimFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_DeltimFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_DeltimFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_DeltimFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_DeltimFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_DeltimPIEDesc.name  := 'HST3D_Deltim';		// name of PIE
	gHST3D_DeltimPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_DeltimPIEDesc.descriptor := @gHST3D_DeltimFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_DeltimPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_DptasFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_DptasFDesc.name := 'HST3D_Dptas';	        // name of function
	gHST3D_DptasFDesc.address := GHST3D_DptasMMFun ;		// function address
	gHST3D_DptasFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_DptasFDesc.numParams :=  1;			// number of parameters
	gHST3D_DptasFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_DptasFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_DptasFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_DptasFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_DptasFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_DptasPIEDesc.name  := 'HST3D_Dptas';		// name of PIE
	gHST3D_DptasPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_DptasPIEDesc.descriptor := @gHST3D_DptasFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_DptasPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_DttasFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_DttasFDesc.name := 'HST3D_Dttas';	        // name of function
	gHST3D_DttasFDesc.address := GHST3D_DttasMMFun ;		// function address
	gHST3D_DttasFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_DttasFDesc.numParams :=  1;			// number of parameters
	gHST3D_DttasFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_DttasFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_DttasFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_DttasFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_DttasFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_DttasPIEDesc.name  := 'HST3D_Dttas';		// name of PIE
	gHST3D_DttasPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_DttasPIEDesc.descriptor := @gHST3D_DttasFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_DttasPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_DctasFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_DctasFDesc.name := 'HST3D_Dctas';	        // name of function
	gHST3D_DctasFDesc.address := GHST3D_DctasMMFun ;		// function address
	gHST3D_DctasFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_DctasFDesc.numParams :=  1;			// number of parameters
	gHST3D_DctasFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_DctasFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_DctasFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_DctasFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_DctasFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_DctasPIEDesc.name  := 'HST3D_Dctas';		// name of PIE
	gHST3D_DctasPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_DctasPIEDesc.descriptor := @gHST3D_DctasFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_DctasPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_DtimmnFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_DtimmnFDesc.name := 'HST3D_Dtimmn';	        // name of function
	gHST3D_DtimmnFDesc.address := GHST3D_DtimmnMMFun ;		// function address
	gHST3D_DtimmnFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_DtimmnFDesc.numParams :=  1;			// number of parameters
	gHST3D_DtimmnFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_DtimmnFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_DtimmnFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_DtimmnFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_DtimmnFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_DtimmnPIEDesc.name  := 'HST3D_Dtimmn';		// name of PIE
	gHST3D_DtimmnPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_DtimmnPIEDesc.descriptor := @gHST3D_DtimmnFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_DtimmnPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_DtimmxFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_DtimmxFDesc.name := 'HST3D_Dtimmx';	        // name of function
	gHST3D_DtimmxFDesc.address := GHST3D_DtimmxMMFun ;		// function address
	gHST3D_DtimmxFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_DtimmxFDesc.numParams :=  1;			// number of parameters
	gHST3D_DtimmxFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_DtimmxFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_DtimmxFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_DtimmxFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_DtimmxFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_DtimmxPIEDesc.name  := 'HST3D_Dtimmx';		// name of PIE
	gHST3D_DtimmxPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_DtimmxPIEDesc.descriptor := @gHST3D_DtimmxFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_DtimmxPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_TimchgFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_TimchgFDesc.name := 'HST3D_Timchg';	        // name of function
	gHST3D_TimchgFDesc.address := GHST3D_TimchgMMFun ;		// function address
	gHST3D_TimchgFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_TimchgFDesc.numParams :=  1;			// number of parameters
	gHST3D_TimchgFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_TimchgFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_TimchgFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_TimchgFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_TimchgFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_TimchgPIEDesc.name  := 'HST3D_Timchg';		// name of PIE
	gHST3D_TimchgPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_TimchgPIEDesc.descriptor := @gHST3D_TimchgFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_TimchgPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // Max number of solver times
	gHST3D_MaxSolverTimesFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_MaxSolverTimesFDesc.name := 'HST3D_MaxSolverTimes';	        // name of function
	gHST3D_MaxSolverTimesFDesc.address := GHST3D_MaxSolverTimesMMFun ;		// function address
	gHST3D_MaxSolverTimesFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_MaxSolverTimesFDesc.numParams :=  0;			// number of parameters
	gHST3D_MaxSolverTimesFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_MaxSolverTimesFDesc.paramNames := nil;		// pointer to parameter names list
	gHST3D_MaxSolverTimesFDesc.paramTypes := nil;	// pointer to parameters types list
	gHST3D_MaxSolverTimesFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_MaxSolverTimesFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_MaxSolverTimesPIEDesc.name  := 'HST3D_MaxSolverTimes';		// name of PIE
	gHST3D_MaxSolverTimesPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_MaxSolverTimesPIEDesc.descriptor := @gHST3D_MaxSolverTimesFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_MaxSolverTimesPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return top of unit
	gHST3D_TopFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_TopFDesc.name := 'HST3D_UnitTop';	        // name of function
	gHST3D_TopFDesc.address := GHST3D_TopUnitMMFun ;		// function address
	gHST3D_TopFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_TopFDesc.numParams :=  1;			// number of parameters
	gHST3D_TopFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_TopFDesc.paramNames := @gpnUnit;		// pointer to parameter names list
	gHST3D_TopFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_TopFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_TopFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_TopPIEDesc.name  := 'HST3D_UnitTop';		// name of PIE
	gHST3D_TopPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_TopPIEDesc.descriptor := @gHST3D_TopFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_TopPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return bottom of unit
	gHST3D_BottomFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_BottomFDesc.name := 'HST3D_UnitBottom';	        // name of function
	gHST3D_BottomFDesc.address := GHST3D_BottomUnitMMFun ;		// function address
	gHST3D_BottomFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_BottomFDesc.numParams :=  1;			// number of parameters
	gHST3D_BottomFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_BottomFDesc.paramNames := @gpnUnit;		// pointer to parameter names list
	gHST3D_BottomFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_BottomFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_BottomFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_BottomPIEDesc.name  := 'HST3D_UnitBottom';		// name of PIE
	gHST3D_BottomPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_BottomPIEDesc.descriptor := @gHST3D_BottomFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_BottomPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return top of cell layer
	gHST3D_CellTopFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_CellTopFDesc.name := 'HST3D_CellTop';	        // name of function
	gHST3D_CellTopFDesc.address := GHST3D_CellTopUnitMMFun ;		// function address
	gHST3D_CellTopFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_CellTopFDesc.numParams :=  1;			// number of parameters
	gHST3D_CellTopFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_CellTopFDesc.paramNames := @gpnNodeLayer;		// pointer to parameter names list
	gHST3D_CellTopFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_CellTopFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_CellTopFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_CellTopPIEDesc.name  := 'HST3D_CellTop';		// name of PIE
	gHST3D_CellTopPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_CellTopPIEDesc.descriptor := @gHST3D_CellTopFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_CellTopPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return bottom of cell layer
	gHST3D_CellBottomFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_CellBottomFDesc.name := 'HST3D_CellBottom';	        // name of function
	gHST3D_CellBottomFDesc.address := GHST3D_CellBottomUnitMMFun ;		// function address
	gHST3D_CellBottomFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_CellBottomFDesc.numParams :=  1;			// number of parameters
	gHST3D_CellBottomFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_CellBottomFDesc.paramNames := @gpnNodeLayer;		// pointer to parameter names list
	gHST3D_CellBottomFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_CellBottomFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_CellBottomFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_CellBottomPIEDesc.name  := 'HST3D_CellBottom';		// name of PIE
	gHST3D_CellBottomPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_CellBottomPIEDesc.descriptor := @gHST3D_CellBottomFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_CellBottomPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Node location for heat conduction boundary
	gHST3D_HeatNodeLocFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_HeatNodeLocFDesc.name := 'HST3D_HeatNodeLoc';	        // name of function
	gHST3D_HeatNodeLocFDesc.address := GHST3D_HeatBoundNodeLocationMMFun ;		// function address
	gHST3D_HeatNodeLocFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_HeatNodeLocFDesc.numParams :=  1;			// number of parameters
	gHST3D_HeatNodeLocFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_HeatNodeLocFDesc.paramNames := @gpnNode;		// pointer to parameter names list
	gHST3D_HeatNodeLocFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_HeatNodeLocFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_HeatNodeLocFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_HeatNodeLocPIEDesc.name  := 'HST3D_HeatNodeLoc';		// name of PIE
	gHST3D_HeatNodeLocPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_HeatNodeLocPIEDesc.descriptor := @gHST3D_HeatNodeLocFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_HeatNodeLocPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Node location for initial heat conduction boundary
	gHST3D_InitHeatNodeLocFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_InitHeatNodeLocFDesc.name := 'HST3D_InitHeatNodeLoc';	        // name of function
	gHST3D_InitHeatNodeLocFDesc.address := GHST3D_InitialHeatBoundNodeLocationMMFun ;		// function address
	gHST3D_InitHeatNodeLocFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_InitHeatNodeLocFDesc.numParams :=  1;			// number of parameters
	gHST3D_InitHeatNodeLocFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_InitHeatNodeLocFDesc.paramNames := @gpnNode;		// pointer to parameter names list
	gHST3D_InitHeatNodeLocFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_InitHeatNodeLocFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_InitHeatNodeLocFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_InitHeatNodeLocPIEDesc.name  := 'HST3D_InitHeatNodeLoc';		// name of PIE
	gHST3D_InitHeatNodeLocPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_InitHeatNodeLocPIEDesc.descriptor := @gHST3D_InitHeatNodeLocFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_InitHeatNodeLocPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Temperature for initial heat conduction boundary
	gHST3D_InitHeatNodeTempFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_InitHeatNodeTempFDesc.name := 'HST3D_InitHeatNodeTemp';	        // name of function
	gHST3D_InitHeatNodeTempFDesc.address := GHST3D_InitialHeatBoundNodeLocationMMFun ;		// function address
	gHST3D_InitHeatNodeTempFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_InitHeatNodeTempFDesc.numParams :=  1;			// number of parameters
	gHST3D_InitHeatNodeTempFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_InitHeatNodeTempFDesc.paramNames := @gpnNode;		// pointer to parameter names list
	gHST3D_InitHeatNodeTempFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_InitHeatNodeTempFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_InitHeatNodeTempFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_InitHeatNodeTempPIEDesc.name  := 'HST3D_InitHeatNodeTemp';		// name of PIE
	gHST3D_InitHeatNodeTempPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_InitHeatNodeTempPIEDesc.descriptor := @gHST3D_InitHeatNodeTempFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_InitHeatNodeTempPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Prislm
	gHST3D_PrislmFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PrislmFDesc.name := 'HST3D_Prislm';	        // name of function
	gHST3D_PrislmFDesc.address := GHST3D_PrislmMMFun ;		// function address
	gHST3D_PrislmFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PrislmFDesc.numParams :=  1;			// number of parameters
	gHST3D_PrislmFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PrislmFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PrislmFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PrislmFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PrislmFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PrislmPIEDesc .name  := 'HST3D_Prislm';		// name of PIE
	gHST3D_PrislmPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PrislmPIEDesc .descriptor := @gHST3D_PrislmFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PrislmPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Prikd
	gHST3D_PrikdFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PrikdFDesc.name := 'HST3D_Prikd';	        // name of function
	gHST3D_PrikdFDesc.address := GHST3D_PrikdMMFun ;		// function address
	gHST3D_PrikdFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PrikdFDesc.numParams :=  1;			// number of parameters
	gHST3D_PrikdFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PrikdFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PrikdFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PrikdFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PrikdFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PrikdPIEDesc .name  := 'HST3D_Prikd';		// name of PIE
	gHST3D_PrikdPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PrikdPIEDesc .descriptor := @gHST3D_PrikdFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PrikdPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Priptc
	gHST3D_PriptcFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PriptcFDesc.name := 'HST3D_Priptc';	        // name of function
	gHST3D_PriptcFDesc.address := GHST3D_PriptcMMFun ;		// function address
	gHST3D_PriptcFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PriptcFDesc.numParams :=  1;			// number of parameters
	gHST3D_PriptcFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PriptcFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PriptcFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PriptcFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PriptcFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PriptcPIEDesc .name  := 'HST3D_Priptc';		// name of PIE
	gHST3D_PriptcPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PriptcPIEDesc .descriptor := @gHST3D_PriptcFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PriptcPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Pridv
	gHST3D_PridvFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PridvFDesc.name := 'HST3D_Pridv';	        // name of function
	gHST3D_PridvFDesc.address := GHST3D_PridvMMFun ;		// function address
	gHST3D_PridvFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PridvFDesc.numParams :=  1;			// number of parameters
	gHST3D_PridvFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PridvFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PridvFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PridvFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PridvFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PridvPIEDesc .name  := 'HST3D_Pridv';		// name of PIE
	gHST3D_PridvPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PridvPIEDesc .descriptor := @gHST3D_PridvFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PridvPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Privel
	gHST3D_PrivelFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PrivelFDesc.name := 'HST3D_Privel';	        // name of function
	gHST3D_PrivelFDesc.address := GHST3D_PrivelMMFun ;		// function address
	gHST3D_PrivelFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PrivelFDesc.numParams :=  1;			// number of parameters
	gHST3D_PrivelFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PrivelFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PrivelFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PrivelFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PrivelFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PrivelPIEDesc .name  := 'HST3D_Privel';		// name of PIE
	gHST3D_PrivelPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PrivelPIEDesc .descriptor := @gHST3D_PrivelFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PrivelPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Prigfb
	gHST3D_PrigfbFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PrigfbFDesc.name := 'HST3D_Prigfb';	        // name of function
	gHST3D_PrigfbFDesc.address := GHST3D_PrigfbMMFun ;		// function address
	gHST3D_PrigfbFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PrigfbFDesc.numParams :=  1;			// number of parameters
	gHST3D_PrigfbFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PrigfbFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PrigfbFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PrigfbFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PrigfbFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PrigfbPIEDesc .name  := 'HST3D_Prigfb';		// name of PIE
	gHST3D_PrigfbPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PrigfbPIEDesc .descriptor := @gHST3D_PrigfbFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PrigfbPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Pribcf
	gHST3D_PribcfFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PribcfFDesc.name := 'HST3D_Pribcf';	        // name of function
	gHST3D_PribcfFDesc.address := GHST3D_PribcfMMFun ;		// function address
	gHST3D_PribcfFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PribcfFDesc.numParams :=  1;			// number of parameters
	gHST3D_PribcfFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PribcfFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PribcfFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PribcfFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PribcfFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PribcfPIEDesc .name  := 'HST3D_Pribcf';		// name of PIE
	gHST3D_PribcfPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PribcfPIEDesc .descriptor := @gHST3D_PribcfFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PribcfPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Priwel
	gHST3D_PriwelFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PriwelFDesc.name := 'HST3D_Priwel';	        // name of function
	gHST3D_PriwelFDesc.address := GHST3D_PriwelMMFun ;		// function address
	gHST3D_PriwelFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PriwelFDesc.numParams :=  1;			// number of parameters
	gHST3D_PriwelFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PriwelFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PriwelFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PriwelFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PriwelFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PriwelPIEDesc .name  := 'HST3D_Priwel';		// name of PIE
	gHST3D_PriwelPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PriwelPIEDesc .descriptor := @gHST3D_PriwelFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PriwelPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Iprptc
	gHST3D_IprptcFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_IprptcFDesc.name := 'HST3D_Iprptc';	        // name of function
	gHST3D_IprptcFDesc.address := GHST3D_IprptcMMFun ;		// function address
	gHST3D_IprptcFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_IprptcFDesc.numParams :=  1;			// number of parameters
	gHST3D_IprptcFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_IprptcFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_IprptcFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_IprptcFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_IprptcFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_IprptcPIEDesc .name  := 'HST3D_Iprptc';		// name of PIE
	gHST3D_IprptcPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_IprptcPIEDesc .descriptor := @gHST3D_IprptcFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_IprptcPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Chkptd
	gHST3D_ChkptdFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_ChkptdFDesc.name := 'HST3D_Chkptd';	        // name of function
	gHST3D_ChkptdFDesc.address := GHST3D_ChkptdMMFun ;		// function address
	gHST3D_ChkptdFDesc.returnType := kPIEBoolean;		// return value type
	gHST3D_ChkptdFDesc.numParams :=  1;			// number of parameters
	gHST3D_ChkptdFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_ChkptdFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_ChkptdFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_ChkptdFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_ChkptdFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_ChkptdPIEDesc .name  := 'HST3D_Chkptd';		// name of PIE
	gHST3D_ChkptdPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_ChkptdPIEDesc .descriptor := @gHST3D_ChkptdFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_ChkptdPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Pricpd
	gHST3D_PricpdFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PricpdFDesc.name := 'HST3D_Pricpd';	        // name of function
	gHST3D_PricpdFDesc.address := GHST3D_PricpdMMFun ;		// function address
	gHST3D_PricpdFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PricpdFDesc.numParams :=  1;			// number of parameters
	gHST3D_PricpdFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PricpdFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PricpdFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PricpdFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PricpdFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PricpdPIEDesc .name  := 'HST3D_Pricpd';		// name of PIE
	gHST3D_PricpdPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PricpdPIEDesc .descriptor := @gHST3D_PricpdFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PricpdPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Savldo
	gHST3D_SavldoFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_SavldoFDesc.name := 'HST3D_Savldo';	        // name of function
	gHST3D_SavldoFDesc.address := GHST3D_SavldoMMFun ;		// function address
	gHST3D_SavldoFDesc.returnType := kPIEBoolean;		// return value type
	gHST3D_SavldoFDesc.numParams :=  1;			// number of parameters
	gHST3D_SavldoFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_SavldoFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_SavldoFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_SavldoFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_SavldoFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_SavldoPIEDesc .name  := 'HST3D_Savldo';		// name of PIE
	gHST3D_SavldoPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_SavldoPIEDesc .descriptor := @gHST3D_SavldoFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_SavldoPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Cntmap
	gHST3D_CntmapFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_CntmapFDesc.name := 'HST3D_Cntmap';	        // name of function
	gHST3D_CntmapFDesc.address := GHST3D_CntmapMMFun ;		// function address
	gHST3D_CntmapFDesc.returnType := kPIEBoolean;		// return value type
	gHST3D_CntmapFDesc.numParams :=  1;			// number of parameters
	gHST3D_CntmapFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_CntmapFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_CntmapFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_CntmapFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_CntmapFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_CntmapPIEDesc .name  := 'HST3D_Cntmap';		// name of PIE
	gHST3D_CntmapPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_CntmapPIEDesc .descriptor := @gHST3D_CntmapFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_CntmapPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Vecmap
	gHST3D_VecmapFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_VecmapFDesc.name := 'HST3D_Vecmap';	        // name of function
	gHST3D_VecmapFDesc.address := GHST3D_VecmapMMFun ;		// function address
	gHST3D_VecmapFDesc.returnType := kPIEBoolean;		// return value type
	gHST3D_VecmapFDesc.numParams :=  1;			// number of parameters
	gHST3D_VecmapFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_VecmapFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_VecmapFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_VecmapFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_VecmapFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_VecmapPIEDesc .name  := 'HST3D_Vecmap';		// name of PIE
	gHST3D_VecmapPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_VecmapPIEDesc .descriptor := @gHST3D_VecmapFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_VecmapPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // return Primap
	gHST3D_PrimapFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_PrimapFDesc.name := 'HST3D_Primap';	        // name of function
	gHST3D_PrimapFDesc.address := GHST3D_PrimapMMFun ;		// function address
	gHST3D_PrimapFDesc.returnType := kPIEInteger;		// return value type
	gHST3D_PrimapFDesc.numParams :=  1;			// number of parameters
	gHST3D_PrimapFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_PrimapFDesc.paramNames := @gpnPeriod;		// pointer to parameter names list
	gHST3D_PrimapFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_PrimapFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_PrimapFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_PrimapPIEDesc .name  := 'HST3D_Primap';		// name of PIE
	gHST3D_PrimapPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_PrimapPIEDesc .descriptor := @gHST3D_PrimapFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PrimapPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_GetZFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetZFDesc.name := 'HST3D_GetZ';	        // name of function
	gHST3D_GetZFDesc.address := GHST3D_GetZMMFun ;		// function address
	gHST3D_GetZFDesc.returnType := kPIEFloat;		// return value type
	gHST3D_GetZFDesc.numParams :=  1;			// number of parameters
	gHST3D_GetZFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_GetZFDesc.paramNames := @gpnNodeLayer;		// pointer to parameter names list
	gHST3D_GetZFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gHST3D_GetZFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_GetZFDesc.neededProject := ProjectName;	// needed project;

       	gHST3D_GetZPIEDesc .name  := 'HST3D_GetZ';		// name of PIE
	gHST3D_GetZPIEDesc .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_GetZPIEDesc .descriptor := @gHST3D_GetZFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetZPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	// Post processing PIE
	//
	gHST3D_PostImportPIEDesc.version := IMPORT_PIE_VERSION;
	gHST3D_PostImportPIEDesc.name := 'HST3D Post-processing...';   // name of project
	gHST3D_PostImportPIEDesc.importFlags := kImportAllwaysVisible or kImportNeedsProject;
 	gHST3D_PostImportPIEDesc.toLayerTypes := (kPIEAnyLayer) {* was kPIETriMeshLayer*/};
 	gHST3D_PostImportPIEDesc.doImportProc := @GPostProcessingPIE;// address of Post Processing Function function
 	gHST3D_PostImportPIEDesc.neededProject := ProjectName;//  needed project;


	gHST3D_PostPIEDesc.name := 'HST3D Post-processing...';      // PIE name
	gHST3D_PostPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gHST3D_PostPIEDesc.descriptor := @gHST3D_PostImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_PostPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_MonthlyImportPIEDesc.version := IMPORT_PIE_VERSION;
	gHST3D_MonthlyImportPIEDesc.name := 'Import Monthly Data';   // name of project
	gHST3D_MonthlyImportPIEDesc.importFlags := kImportFromLayer or kImportNeedsProject;
 	gHST3D_MonthlyImportPIEDesc.fromLayerTypes := kPIEInformationLayer {* was kPIETriMeshLayer*/};
 	gHST3D_MonthlyImportPIEDesc.toLayerTypes := kPIEInformationLayer {* was kPIETriMeshLayer*/};
 	gHST3D_MonthlyImportPIEDesc.doImportProc := @GMonthlyDataPIE;// address Import PIE function
 	gHST3D_MonthlyImportPIEDesc.neededProject := ProjectName;// needed project;

	//
	// prepare PIE descriptor for Import PIE

	gHST3D_MonthlyPIEDesc.name := 'Import Monthly Data';      // PIE name
	gHST3D_MonthlyPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gHST3D_MonthlyPIEDesc.descriptor := @gHST3D_MonthlyImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gHST3D_MonthlyPIEDesc;
        Inc(numNames);	// add descriptor to list

	gHST3D_TemporalImportPIEDesc.version := IMPORT_PIE_VERSION;
	gHST3D_TemporalImportPIEDesc.name := 'Import Temporal Data';   // name of project
	gHST3D_TemporalImportPIEDesc.importFlags := kImportFromLayer or kImportNeedsProject;
 	gHST3D_TemporalImportPIEDesc.fromLayerTypes := kPIEInformationLayer {* was kPIETriMeshLayer*/};
 	gHST3D_TemporalImportPIEDesc.toLayerTypes := kPIEInformationLayer {* was kPIETriMeshLayer*/};
 	gHST3D_TemporalImportPIEDesc.doImportProc := @GTemporalDataPIE;// address Import PIE function
 	gHST3D_TemporalImportPIEDesc.neededProject := ProjectName;// needed project;

	//
	// prepare PIE descriptor for Import PIE

	gHST3D_TemporalPIEDesc.name := 'Import Temporal Data';      // PIE name
	gHST3D_TemporalPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gHST3D_TemporalPIEDesc.descriptor := @gHST3D_TemporalImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gHST3D_TemporalPIEDesc;
        Inc(numNames);	// add descriptor to list

	gHST3D_HelpImportPIEDesc.version := IMPORT_PIE_VERSION;
	gHST3D_HelpImportPIEDesc.name := 'HST3D Help';   // name of project
	gHST3D_HelpImportPIEDesc.importFlags := kImportAllwaysVisible;
 	gHST3D_HelpImportPIEDesc.fromLayerTypes := kPIEAnyLayer {* was kPIETriMeshLayer*/};
 	gHST3D_HelpImportPIEDesc.toLayerTypes := kPIEAnyLayer {* was kPIETriMeshLayer*/};
 	gHST3D_HelpImportPIEDesc.doImportProc := @ShowHST3DHelp;// address Import PIE function
 	gHST3D_HelpImportPIEDesc.neededProject := ProjectName;// needed project;

	// prepare PIE descriptor for Import PIE

	gHST3D_HelpPIEDesc.name := 'HST3D Help';      // PIE name
	gHST3D_HelpPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gHST3D_HelpPIEDesc.descriptor := @gHST3D_HelpImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gHST3D_HelpPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Well completion
	gHST3D_GetWellCompletionFDesc.version := FUNCTION_PIE_VERSION;	                // version of function PIE
	gHST3D_GetWellCompletionFDesc.name := 'HST3D_WellCompletion';	                // name of function
	gHST3D_GetWellCompletionFDesc.address := GHST3D_WellCompletionMMFun ;		// function address
	gHST3D_GetWellCompletionFDesc.returnType := kPIEFloat;		                // return value type
	gHST3D_GetWellCompletionFDesc.numParams :=  1;			                // number of parameters
	gHST3D_GetWellCompletionFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellCompletionFDesc.paramNames := @gpnElementLayer;		        // pointer to parameter names list
	gHST3D_GetWellCompletionFDesc.paramTypes := @gOneIntegerTypes;	                // pointer to parameters types list
	gHST3D_GetWellCompletionFDesc.functionFlags := CurrentFunctionFlags;	        // Options;
	gHST3D_GetWellCompletionFDesc.neededProject := ProjectName;	                // needed project;

       	gHST3D_GetWellCompletionPIEDesc.name  := 'HST3D_WellCompletion';		// name of PIE
	gHST3D_GetWellCompletionPIEDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gHST3D_GetWellCompletionPIEDesc.descriptor := @gHST3D_GetWellCompletionFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellCompletionPIEDesc ;                       // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well skin factor
	gHST3D_GetWellSkinFactorFDesc.version := FUNCTION_PIE_VERSION;	                // version of function PIE
	gHST3D_GetWellSkinFactorFDesc.name := 'HST3D_WellSkinFactor';	                // name of function
	gHST3D_GetWellSkinFactorFDesc.address := GHST3D_WellSkinFactorMMFun ;		// function address
	gHST3D_GetWellSkinFactorFDesc.returnType := kPIEFloat;		                // return value type
	gHST3D_GetWellSkinFactorFDesc.numParams :=  1;			                // number of parameters
	gHST3D_GetWellSkinFactorFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellSkinFactorFDesc.paramNames := @gpnElementLayer;		        // pointer to parameter names list
	gHST3D_GetWellSkinFactorFDesc.paramTypes := @gOneIntegerTypes;	                // pointer to parameters types list
	gHST3D_GetWellSkinFactorFDesc.functionFlags := CurrentFunctionFlags;	        // Options;
	gHST3D_GetWellSkinFactorFDesc.neededProject := ProjectName;	                // needed project;

       	gHST3D_GetWellSkinFactorPIEDesc.name  := 'HST3D_WellSkinFactor';		// name of PIE
	gHST3D_GetWellSkinFactorPIEDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gHST3D_GetWellSkinFactorPIEDesc.descriptor := @gHST3D_GetWellSkinFactorFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellSkinFactorPIEDesc ;                       // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well time
	gHST3D_GetWellTimeFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetWellTimeFDesc.name := 'HST3D_WellTime';	                // name of function
	gHST3D_GetWellTimeFDesc.address := GHST3D_WellTimeMMFun ;		// function address
	gHST3D_GetWellTimeFDesc.returnType := kPIEFloat;		        // return value type
	gHST3D_GetWellTimeFDesc.numParams :=  1;			        // number of parameters
	gHST3D_GetWellTimeFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellTimeFDesc.paramNames := @gpnTime;		        // pointer to parameter names list
	gHST3D_GetWellTimeFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gHST3D_GetWellTimeFDesc.functionFlags := CurrentFunctionFlags;	        // Options;
	gHST3D_GetWellTimeFDesc.neededProject := ProjectName;	                // needed project;

       	gHST3D_GetWellTimePIEDesc.name  := 'HST3D_WellTime';		        // name of PIE
	gHST3D_GetWellTimePIEDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gHST3D_GetWellTimePIEDesc.descriptor := @gHST3D_GetWellTimeFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellTimePIEDesc ;                     // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well flow
	gHST3D_GetWellFlowFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetWellFlowFDesc.name := 'HST3D_WellFlow';	                // name of function
	gHST3D_GetWellFlowFDesc.address := GHST3D_WellFlowMMFun ;		// function address
	gHST3D_GetWellFlowFDesc.returnType := kPIEFloat;		        // return value type
	gHST3D_GetWellFlowFDesc.numParams :=  1;			        // number of parameters
	gHST3D_GetWellFlowFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellFlowFDesc.paramNames := @gpnTime;		        // pointer to parameter names list
	gHST3D_GetWellFlowFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gHST3D_GetWellFlowFDesc.functionFlags := CurrentFunctionFlags;	        // Options;
	gHST3D_GetWellFlowFDesc.neededProject := ProjectName;	                // needed project;

       	gHST3D_GetWellFlowPIEDesc.name  := 'HST3D_WellFlow';		        // name of PIE
	gHST3D_GetWellFlowPIEDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gHST3D_GetWellFlowPIEDesc.descriptor := @gHST3D_GetWellFlowFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellFlowPIEDesc ;                     // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well surface pressure
	gHST3D_GetWellSurfPresFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetWellSurfPresFDesc.name := 'HST3D_WellSurfPres';	        // name of function
	gHST3D_GetWellSurfPresFDesc.address := GHST3D_WellSurfPresMMFun ;	// function address
	gHST3D_GetWellSurfPresFDesc.returnType := kPIEFloat;		        // return value type
	gHST3D_GetWellSurfPresFDesc.numParams :=  1;			        // number of parameters
	gHST3D_GetWellSurfPresFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellSurfPresFDesc.paramNames := @gpnTime;		        // pointer to parameter names list
	gHST3D_GetWellSurfPresFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gHST3D_GetWellSurfPresFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_GetWellSurfPresFDesc.neededProject := ProjectName;	        // needed project;

       	gHST3D_GetWellSurfPresPIEDesc.name  := 'HST3D_WellSurfPres';		// name of PIE
	gHST3D_GetWellSurfPresPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_GetWellSurfPresPIEDesc.descriptor := @gHST3D_GetWellSurfPresFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellSurfPresPIEDesc ;                     // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well datum pressure
	gHST3D_GetWellDatumFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetWellDatumFDesc.name := 'HST3D_WellDatumPres';	        // name of function
	gHST3D_GetWellDatumFDesc.address := GHST3D_WellDatumMMFun ;	// function address
	gHST3D_GetWellDatumFDesc.returnType := kPIEFloat;		        // return value type
	gHST3D_GetWellDatumFDesc.numParams :=  1;			        // number of parameters
	gHST3D_GetWellDatumFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellDatumFDesc.paramNames := @gpnTime;		        // pointer to parameter names list
	gHST3D_GetWellDatumFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gHST3D_GetWellDatumFDesc.functionFlags := CurrentFunctionFlags;	// Options;
	gHST3D_GetWellDatumFDesc.neededProject := ProjectName;	        // needed project;

       	gHST3D_GetWellDatumPIEDesc.name  := 'HST3D_WellDatumPres';		// name of PIE
	gHST3D_GetWellDatumPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_GetWellDatumPIEDesc.descriptor := @gHST3D_GetWellDatumFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellDatumPIEDesc ;                     // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well temperature
	gHST3D_GetWellTempFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetWellTempFDesc.name := 'HST3D_WellTemperature';	        // name of function
	gHST3D_GetWellTempFDesc.address := GHST3D_WellTempMMFun ;	        // function address
	gHST3D_GetWellTempFDesc.returnType := kPIEFloat;		        // return value type
	gHST3D_GetWellTempFDesc.numParams :=  1;			        // number of parameters
	gHST3D_GetWellTempFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellTempFDesc.paramNames := @gpnTime;		        // pointer to parameter names list
	gHST3D_GetWellTempFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gHST3D_GetWellTempFDesc.functionFlags := CurrentFunctionFlags;	        // Options;
	gHST3D_GetWellTempFDesc.neededProject := ProjectName;	                // needed project;

       	gHST3D_GetWellTempPIEDesc.name  := 'HST3D_WellTemperature';		// name of PIE
	gHST3D_GetWellTempPIEDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gHST3D_GetWellTempPIEDesc.descriptor := @gHST3D_GetWellTempFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellTempPIEDesc ;                     // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well mass Fraction
	gHST3D_GetWellMassFracFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetWellMassFracFDesc.name := 'HST3D_WellMassFrac';	        // name of function
	gHST3D_GetWellMassFracFDesc.address := GHST3D_WellMassFracMMFun ;	        // function address
	gHST3D_GetWellMassFracFDesc.returnType := kPIEFloat;		        // return value type
	gHST3D_GetWellMassFracFDesc.numParams :=  1;			        // number of parameters
	gHST3D_GetWellMassFracFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellMassFracFDesc.paramNames := @gpnTime;		        // pointer to parameter names list
	gHST3D_GetWellMassFracFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gHST3D_GetWellMassFracFDesc.functionFlags := CurrentFunctionFlags;	        // Options;
	gHST3D_GetWellMassFracFDesc.neededProject := ProjectName;	                // needed project;

       	gHST3D_GetWellMassFracPIEDesc.name  := 'HST3D_WellMassFrac';		// name of PIE
	gHST3D_GetWellMassFracPIEDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gHST3D_GetWellMassFracPIEDesc.descriptor := @gHST3D_GetWellMassFracFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellMassFracPIEDesc ;                     // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well number of times
	gHST3D_GetWellTimeCountFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetWellTimeCountFDesc.name := 'HST3D_WellTimeCount';	        // name of function
	gHST3D_GetWellTimeCountFDesc.address := GHST3D_WellTimeCountMMFun ;	        // function address
	gHST3D_GetWellTimeCountFDesc.returnType := kPIEInteger;		        // return value type
	gHST3D_GetWellTimeCountFDesc.numParams :=  0;			        // number of parameters
	gHST3D_GetWellTimeCountFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellTimeCountFDesc.paramNames := nil;		        // pointer to parameter names list
	gHST3D_GetWellTimeCountFDesc.paramTypes := nil;	        // pointer to parameters types list
	gHST3D_GetWellTimeCountFDesc.functionFlags := CurrentFunctionFlags;	        // Options;
	gHST3D_GetWellTimeCountFDesc.neededProject := ProjectName;	                // needed project;

       	gHST3D_GetWellTimeCountPIEDesc.name  := 'HST3D_WellTimeCount';		// name of PIE
	gHST3D_GetWellTimeCountPIEDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gHST3D_GetWellTimeCountPIEDesc.descriptor := @gHST3D_GetWellTimeCountFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellTimeCountPIEDesc ;                     // add descriptor to list
        Inc(numNames);	// increment number of names

        // Well number of element layers
	
        gHST3D_GetWellElementCountFDesc.version := FUNCTION_PIE_VERSION;	        // version of function PIE
	gHST3D_GetWellElementCountFDesc.name := 'HST3D_WellElementCount';	        // name of function
	gHST3D_GetWellElementCountFDesc.address := GHST3D_WellElementCountMMFun ;	        // function address
	gHST3D_GetWellElementCountFDesc.returnType := kPIEInteger;		        // return value type
	gHST3D_GetWellElementCountFDesc.numParams :=  0;			        // number of parameters
	gHST3D_GetWellElementCountFDesc.numOptParams := 0;			        // number of optional parameters
	gHST3D_GetWellElementCountFDesc.paramNames := nil;		        // pointer to parameter names list
	gHST3D_GetWellElementCountFDesc.paramTypes := nil;	        // pointer to parameters types list
	gHST3D_GetWellElementCountFDesc.functionFlags := CurrentFunctionFlags;	        // Options;
	gHST3D_GetWellElementCountFDesc.neededProject := ProjectName;	                // needed project;

       	gHST3D_GetWellElementCountPIEDesc.name  := 'HST3D_WellElementCount';		// name of PIE
	gHST3D_GetWellElementCountPIEDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gHST3D_GetWellElementCountPIEDesc.descriptor := @gHST3D_GetWellElementCountFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_GetWellElementCountPIEDesc  ;                     // add descriptor to list
        Inc(numNames);	// increment number of names


        // Import PIE descriptor
	gHST3D_CalcCoordImportPIEDesc.version := IMPORT_PIE_VERSION;
	gHST3D_CalcCoordImportPIEDesc.name := 'Calculate Coordinate';   // name of project
	gHST3D_CalcCoordImportPIEDesc.importFlags := kImportNeedsProject or kImportAllwaysVisible;
 	gHST3D_CalcCoordImportPIEDesc.fromLayerTypes := kPIEAnyLayer {* was kPIETriMeshLayer*/};
 	gHST3D_CalcCoordImportPIEDesc.toLayerTypes := kPIEAnyLayer {* was kPIETriMeshLayer*/};
 	gHST3D_CalcCoordImportPIEDesc.doImportProc := @CalculateCoordinate;// address Import PIE function
 	gHST3D_CalcCoordImportPIEDesc.neededProject := ProjectName;// needed project;

	// prepare PIE descriptor for Import PIE

	gHST3D_CalcCoordPIEDesc.name := 'Calculate Coordinate';      // PIE name
	gHST3D_CalcCoordPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gHST3D_CalcCoordPIEDesc.descriptor := @gHST3D_CalcCoordImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gHST3D_CalcCoordPIEDesc;
        Inc(numNames);	// add descriptor to list



        // Import PIE descriptor
	gHST3D_GridImportPIEDesc.version := IMPORT_PIE_VERSION;
	gHST3D_GridImportPIEDesc.name := 'Create Observation Grid';   // name of project
	gHST3D_GridImportPIEDesc.importFlags := kImportNeedsProject or kImportAllwaysVisible;
 	gHST3D_GridImportPIEDesc.fromLayerTypes := kPIEAnyLayer {* was kPIETriMeshLayer*/};
 	gHST3D_GridImportPIEDesc.toLayerTypes := kPIEAnyLayer {* was kPIETriMeshLayer*/};
 	gHST3D_GridImportPIEDesc.doImportProc := @CreateObservationGrid;// address Import PIE function
 	gHST3D_GridImportPIEDesc.neededProject := ProjectName;// needed project;

	// prepare PIE descriptor for Import PIE

	gHST3D_GridPIEDesc.name := 'Create Observation Grid';      // PIE name
	gHST3D_GridPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gHST3D_GridPIEDesc.descriptor := @gHST3D_GridImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gHST3D_GridPIEDesc;
        Inc(numNames);	// add descriptor to list

	// Time Series PIE
	//
	gHST3D_TimeSeriesImportPIEDesc.version := IMPORT_PIE_VERSION;
	gHST3D_TimeSeriesImportPIEDesc.name := 'HST3D Time Series...';   // name of project
	gHST3D_TimeSeriesImportPIEDesc.importFlags := kImportAllwaysVisible or kImportNeedsProject;
 	gHST3D_TimeSeriesImportPIEDesc.toLayerTypes := (kPIEAnyLayer) {* was kPIETriMeshLayer*/};
 	gHST3D_TimeSeriesImportPIEDesc.doImportProc := @GTimeSeriesPIE;// address of Post Processing Function function
 	gHST3D_TimeSeriesImportPIEDesc.neededProject := ProjectName;//  needed project;


	gHST3D_TimeSeriesPIEDesc.name := 'HST3D Time Series...';      // PIE name
	gHST3D_TimeSeriesPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gHST3D_TimeSeriesPIEDesc.descriptor := @gHST3D_TimeSeriesImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_TimeSeriesPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gHST3D_RenameFileFDesc.name := 'HST3D_RenameFiles';	        // name of function
	gHST3D_RenameFileFDesc.address := GPIERenameFilesMMFun;		// function address
	gHST3D_RenameFileFDesc.returnType := kPIEBoolean;		// returns True if it succeeds and False if it fails
	gHST3D_RenameFileFDesc.numParams :=  2;			// number of parameters
	gHST3D_RenameFileFDesc.numOptParams := 0;			// number of optional parameters
	gHST3D_RenameFileFDesc.paramNames := @gpn2File;		// pointer to parameter names list
	gHST3D_RenameFileFDesc.paramTypes := @g2StringType;	// pointer to parameters types list

       	gHST3D_RenameFileDesc.name  := 'HST3D_RenameFiles';		// name of PIE
	gHST3D_RenameFileDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gHST3D_RenameFileDesc.descriptor := @gHST3D_RenameFileFDesc;	// pointer to descriptor

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gHST3D_RenameFileDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gPIEDesc;

end;


end.
