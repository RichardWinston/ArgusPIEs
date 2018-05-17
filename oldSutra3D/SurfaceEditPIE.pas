unit SurfaceEditPIE;

interface

uses SysUtils, Controls, Forms, Dialogs, AnePIE, ImportPIE, ANECB;

procedure EditSurfaces(aneHandle : ANE_PTR;
  const fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

implementation

uses frmSutraUnit, ANE_LayerUnit, ArgusFormUnit, LayerSelectUnit,
  SLSourcesOfFluid, SLEnergySoluteSources, SLSpecifiedPressure,
  SLSpecConcOrTemp, SurfaceEdit;

procedure EditSurfaces(aneHandle : ANE_PTR;
  const fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
Var
  UnitIndex : integer;
  UnitString : String;
  LayerName : string;
  SurfaceLayerHandle : ANE_PTR;
  OK : boolean;

begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not edit surface contours' +
    ' if an edit box is open. Try again after'
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

        OK := frmSutra.Is3D;

        if not OK then
        begin
          MessageDlg('You must be editting a three-dimensional'
            + 'model to use the option.', mtWarning, [mbOK], 0);
        end
        else
        begin
          SurfaceLayerHandle := nil;
          frmLayerSelect:= TfrmLayerSelect.Create(Application);
          try
            with frmLayerSelect do
            begin
              for UnitIndex := 1 to StrToInt(frmSutra.adeBoundLayerCount.Text) do
              begin
                UnitString := IntToStr(UnitIndex);
                rgLayers.Items.Add
                  (TSurfaceFluidSourcesLayer.WriteNewRoot + UnitString);
                rgLayers.Items.Add
                  (TSurfaceSoluteEnergySourcesLayer.WriteNewRoot + UnitString);
                rgLayers.Items.Add
                  (TSpecifiedPressureSurfaceLayer.WriteNewRoot + UnitString);
                rgLayers.Items.Add
                  (TSurfaceSpecConcTempLayer.WriteNewRoot + UnitString);
              end;
              SetHeight;
              if (ShowModal = mrOK) and (rgLayers.ItemIndex > -1) then
              begin
                LayerName := rgLayers.Items[frmLayerSelect.rgLayers.ItemIndex];
                SurfaceLayerHandle :=
                  ANE_LayerGetHandleByName(aneHandle,PChar(LayerName));
              end;
            end;
          finally
            frmLayerSelect.Free;
          end;

          if SurfaceLayerHandle <> nil then
          begin
            frmSurfaceEdit:= TfrmSurfaceEdit.Create(Application);
            try
              frmSurfaceEdit.CreateContours(aneHandle, SurfaceLayerHandle);
              frmSurfaceEdit.sbZoomExtentsClick(frmSurfaceEdit.sbZoomExtents);
              if frmSurfaceEdit.ShowModal = mrOK then
              begin
                frmSurfaceEdit.SetContourValues(aneHandle{, SurfaceLayerHandle});
              end;
            finally
              frmSurfaceEdit.Free;
            end;

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

end.
