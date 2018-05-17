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
  SysUtils, Classes, Controls, Dialogs, Forms,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, frmEditGridUnit, ChooseLayerUnit, OptionsUnit, ANE_LayerUnit,
  UtilityFunctions, frmGridTypeUnit;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 1;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gDelphiPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDelphiPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

function GetLayerHandle(aneHandle : ANE_PTR): ANE_PTR;
var
  Project : TProjectOptions;
  GridLayer : T_ANE_NamedGridLayer;
  ParamIndex : integer;
  Param : T_ANE_NamedGridParam;
  ParamTypeList : TStringList;
  Template : string;
  DomainOutline: T_ANE_NamedDomainOutlineLayer;
  DensityLayer : T_ANE_NamedInfoLayer;
  ANE_LayerTemplate : ANE_STR;
//  An_ANE_STR : ANE_STR;
  Procedure SetDefaultLayer;
  begin
    frmChooseLayer.cbNewLayer.Checked := False;
    frmChooseLayer.seParamCount.Value := 1;
    if frmChooseLayer.dgParameters.ColCount > 1 then
    begin
      frmChooseLayer.FormCreate(frmChooseLayer);
    end;
    if frmChooseLayer.comboLayerNames.Items.Count > 0 then
    begin
      frmChooseLayer.comboLayerNames.ItemIndex := 0;
    end;
  end;
begin
  result := nil;
  DomainOutline := nil;
  DensityLayer := nil;
  Application.CreateForm(TfrmChooseLayer, frmChooseLayer);
  try
    frmChooseLayer.ModelHandle := aneHandle;
    Project := TProjectOptions.Create;
    try
      Project.LayerNames(aneHandle, [pieGridLayer],
        frmChooseLayer.comboLayerNames.Items);
      SetDefaultLayer;
      if frmChooseLayer.ShowModal = mrOK then
      begin
        if frmChooseLayer.cbNewLayer.Checked then
        begin
          GridLayer := T_ANE_NamedGridLayer.Create(
            frmChooseLayer.comboLayerNames.Text, nil, -1);

          Application.CreateForm(TfrmGridType, frmGridType);
          try
            frmGridType.ShowModal;
            GridLayer.BlockCenteredGrid :=
              frmGridType.rgGridType.ItemIndex = 0;
          finally
            frmGridType.Free;
          end;

          ParamTypeList := TStringList.Create;
          try
            ParamTypeList.Assign(frmChooseLayer.dgParameters.Columns[1].Picklist);

            for ParamIndex := 1 to frmChooseLayer.seParamCount.Value do
            begin
              Param := T_ANE_NamedGridParam.Create(
                frmChooseLayer.dgParameters.Cells[0,ParamIndex],
                GridLayer.ParamList,-1);
              case ParamTypeList.IndexOf(
                frmChooseLayer.dgParameters.Cells[1,ParamIndex]) of
                0:
                  begin
                    Param.ValueType := pvReal;
                  end;
                1:
                  begin
                    Param.ValueType := pvInteger;
                  end;
                2:
                  begin
                    Param.ValueType := pvBoolean;
                  end;
                3:
                  begin
                    Param.ValueType := pvString;
                  end;
              else Assert(False);
              end; // end case
            end; // for ParamIndex := 1

            frmChooseLayer.comboLayerNames.Items.Clear;
            Project.LayerNames(aneHandle, [pieDomainLayer],
              frmChooseLayer.comboLayerNames.Items);
            SetDefaultLayer;
            frmChooseLayer.dgParameters.ColCount := 1;
            if frmChooseLayer.ShowModal = mrOK then
            begin
              if frmChooseLayer.cbNewLayer.Checked then
              begin
                DomainOutline := T_ANE_NamedDomainOutlineLayer.Create(
                  frmChooseLayer.comboLayerNames.Text, nil, -1);
                for ParamIndex := 1 to frmChooseLayer.seParamCount.Value do
                begin
                  T_ANE_NamedLayerParam.Create(
                    frmChooseLayer.dgParameters.Cells[0,ParamIndex],
                    DomainOutline.ParamList,-1);
                end; // for ParamIndex := 1
              end; // if frmChooseLayer.cbNewLayer.Checked then
              GridLayer.DomainLayer := frmChooseLayer.comboLayerNames.Text;
            end
            else
            begin
              Exit;
            end; // if frmChooseLayer.ShowModal = mrOK


            frmChooseLayer.comboLayerNames.Items.Clear;
            Project.LayerNames(aneHandle, [pieInformationLayer],
              frmChooseLayer.comboLayerNames.Items);
            SetDefaultLayer;
            if frmChooseLayer.ShowModal = mrOK then
            begin
              if frmChooseLayer.cbNewLayer.Checked then
              begin
                DensityLayer := T_ANE_NamedInfoLayer.Create(
                  frmChooseLayer.comboLayerNames.Text, nil, -1);
                for ParamIndex := 1 to frmChooseLayer.seParamCount.Value do
                begin
                  T_ANE_NamedLayerParam.Create(
                    frmChooseLayer.dgParameters.Cells[0,ParamIndex],
                    DensityLayer.ParamList,-1);
                end; // for ParamIndex := 1
              end; // if frmChooseLayer.cbNewLayer.Checked
              GridLayer.DensityLayer := frmChooseLayer.comboLayerNames.Text;
            end
            else
            begin
              Exit;
            end; // if frmChooseLayer.ShowModal = mrOK

            if DomainOutline <> nil then
            begin
              Template := DomainOutline.WriteLayer(aneHandle);
              GetMem(ANE_LayerTemplate, Length(Template) + 1);
              try
                StrPCopy(ANE_LayerTemplate, Template);
                ANE_LayerAddByTemplate(aneHandle, ANE_LayerTemplate, nil);
              finally
                FreeMem(ANE_LayerTemplate);
              end;
            end;
            if DensityLayer <> nil then
            begin
              Template := DensityLayer.WriteLayer(aneHandle);
              GetMem(ANE_LayerTemplate, Length(Template) + 1);
              try
                StrPCopy(ANE_LayerTemplate, Template);
                ANE_LayerAddByTemplate(aneHandle, ANE_LayerTemplate, nil);
              finally
                FreeMem(ANE_LayerTemplate);
              end;
            end;
            Template := GridLayer.WriteLayer(aneHandle);
            GetMem(ANE_LayerTemplate, Length(Template) + 1);
            try
              StrPCopy(ANE_LayerTemplate, Template);
              result := ANE_LayerAddByTemplate(aneHandle,
                ANE_LayerTemplate, nil);
            finally
              FreeMem(ANE_LayerTemplate);
            end;

          finally
            ParamTypeList.Free;
            GridLayer.Free;
            DomainOutline.Free;
            DensityLayer.Free;
          end;
        end
        else
        begin
          result := UtilityFunctions.GetLayerHandle(aneHandle,
            frmChooseLayer.comboLayerNames.Text);
{          GetMem(An_ANE_STR, Length(frmChooseLayer.comboLayerNames.Text) + 1);
          try
            StrPCopy(An_ANE_STR,frmChooseLayer.comboLayerNames.Text);
            result := ANE_LayerGetHandleByName(aneHandle, An_ANE_STR);
          finally
            FreeMem(An_ANE_STR);
          end;  }
        end;
      end;
    finally
      Project.Free;
    end;
  finally
    frmChooseLayer.Free;

  end;
end;


// import data from a text file.
procedure GEditGridPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

begin
  layerHandle := GetLayerHandle(aneHandle);
  if layerHandle <> nil then
  begin
    Application.CreateForm(TfrmEditGrid, frmEditGrid);
    try
      frmEditGrid.CurrentModelHandle := aneHandle;

      frmEditGrid.LayerHandle := layerHandle;
      frmEditGrid.GetGrid;
      frmEditGrid.ShowModal;
    finally
      frmEditGrid.Free;
    end;
  end;
end;



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;
	gDelphiPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gDelphiPIEImportPIEDesc.name := 'Edit Grid';   // name of project
	gDelphiPIEImportPIEDesc.importFlags := kImportAllwaysVisible;
 	gDelphiPIEImportPIEDesc.toLayerTypes := kPIEAnyLayer;
 	gDelphiPIEImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
 	gDelphiPIEImportPIEDesc.doImportProc := @GEditGridPIE;// address of Post Processing Function function

	//
	// prepare PIE descriptor for Example Delphi PIE

	gDelphiPIEDesc.name := 'Edit Grid';      // PIE name
	gDelphiPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gDelphiPIEDesc.descriptor := @gDelphiPIEImportPIEDesc;	// pointer to descriptor

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gDelphiPIEDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;



end.
 