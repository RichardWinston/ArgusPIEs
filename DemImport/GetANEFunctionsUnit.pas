unit GetANEFunctionsUnit;

interface

uses Sysutils, Controls, Forms, Dialogs, AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses ImportPIE, frmDEM_Unit, frmLayerNameUnit;

const
  kMaxFunDesc = 1;

var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gImportDEM_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gImportDEM_ImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

procedure GImportDEM(aneHandle : ANE_PTR; const  fileName : ANE_STR;
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
      frmLayerName.CurrentModelHandle := aneHandle;
      frmLayerName.rgLayerTypeClick(nil);
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
        Application.CreateForm(TfrmDEM2BMP, frmDEM2BMP);
        try
          frmDEM2BMP.CurrentModelHandle := aneHandle;
          if IsGridLayer then
          begin
            if IsBlockCentered then
            begin
              frmDEM2BMP.GetBlockCenteredGrid(LayerName);
            end
            else
            begin
              frmDEM2BMP.GetNodeCenteredGrid(LayerName);
            end;
          end
          else
          begin
            frmDEM2BMP.GetMeshWithName(LayerName);
          end;
          frmDEM2BMP.ShowModal;
        finally
          frmDEM2BMP.Free;
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

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
	numNames := 0;
	gImportDEM_ImportPIEDesc.version := IMPORT_PIE_VERSION;
	gImportDEM_ImportPIEDesc.name := 'Import DEM data';   // name of project
	gImportDEM_ImportPIEDesc.importFlags := kImportAllwaysVisible;
 	gImportDEM_ImportPIEDesc.toLayerTypes := kPIEAnyLayer;
 	gImportDEM_ImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
 	gImportDEM_ImportPIEDesc.doImportProc := @GImportDEM;// address of Post Processing Function function

	//
	// prepare PIE descriptor for Example Delphi PIE

	gImportDEM_PIEDesc.name := 'Import DEM data';      // PIE name
	gImportDEM_PIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gImportDEM_PIEDesc.descriptor := @gImportDEM_ImportPIEDesc;	// pointer to descriptor

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gImportDEM_PIEDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;

end.
 