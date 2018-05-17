unit GetLayerUnit;

interface

uses Dialogs, Sysutils, ANEPIE;

procedure GGetMODFLOWLayer (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses ParamArrayUnit, ANE_LayerUnit, Variables, ArgusFormUnit,
  ModflowLayerFunctions, OptionsUnit, ModflowUnit;

var
  WarningGiven : boolean = False;

procedure GGetMODFLOWLayer (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  X, Y : ANE_DOUBLE;
  result : ANE_INT32;
  param : PParameter_array;
  Elevation : ANE_DOUBLE;
  param1_ptr : ANE_DOUBLE_PTR;
  NumUnits : integer;
  UnitIndex : integer;
  TopName, BottomName : String;
  TopLayer, BottomLayer: TLayerOptions;
  Project : TProjectOptions;
  topLayerHandle, BottomLayerHandle : ANE_PTR;
  TopElev, BotElev : ANE_DOUBLE;
  DontUpdateForm : boolean;
//  LocalForm : TfrmModflow;
//  count : integer;
begin
  DontUpdateForm := False;
  result := -1;
  if EditWindowOpen then
  begin
    DontUpdateForm := True;
//        ANE_INT32_PTR(reply)^ := result;
{    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0); }
  end;
//  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try

        X := refPtX^;
        Y := refPtY^;

        if not DontUpdateForm then
        begin
          frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
            as ModflowTypes.GetModflowFormType;
//          LocalForm := TArgusForm.GetFormFromArgus(funHandle)
//            as TfrmModflow;
        end;

        param := @parameters^;
        param1_ptr :=  param^[0];
        Elevation :=  param1_ptr^;

        NumUnits := StrToInt(frmMODFLOW.edNumUnits.Text);
        Project := TProjectOptions.Create;
        try
          for UnitIndex := 1 to NumUnits do
          begin
            if UnitSimulated(UnitIndex) then
//            if (LocalForm.dgGeol.Cells[Ord(nuiSim), UnitIndex] =
//                LocalForm.dgGeol.Columns[Ord(nuiSim)].Picklist.Strings[1]) then
            begin
              TopName := ModflowTypes.GetMFTopElevLayerType.WriteNewRoot
                + IntToStr(UnitIndex);
              BottomName := ModflowTypes.GetBottomElevLayerType.WriteNewRoot
                + IntToStr(UnitIndex);
              topLayerHandle := Project.GetLayerByName(funHandle,TopName);
              BottomLayerHandle := Project.GetLayerByName(funHandle,BottomName);
              TopLayer := TLayerOptions.Create(topLayerHandle);
              BottomLayer := TLayerOptions.Create(BottomLayerHandle);
              try
                TopElev := TopLayer.RealValueAtXY(funHandle,X,Y,TopName);
                BotElev := BottomLayer.RealValueAtXY(funHandle,X,Y,BottomName);
                if Elevation > TopElev then
                begin
                  result := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex) + 1;
                  break;
                end
                else if BotElev > Elevation then
                begin
                  result := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex)
                    + LayerDiscretization(UnitIndex);
                end
                else
                begin
                  result := frmMODFLOW.ModflowLayer(UnitIndex, TopElev,
                    BotElev, Elevation);
                  break;
                end;
              finally
                TopLayer.Free(funHandle);
                BottomLayer.Free(funHandle);
              end;
            end;
          end;
        finally
          Project.Free;
        end;
        ANE_INT32_PTR(reply)^ := result;

      except On E: Exception do
        begin
{          if not DontUpdateForm then
          begin  }
//            MessageDlg(E.Message, mtError, [mbOK], 0);
            ANE_INT32_PTR(reply)^ := 1;
            Beep;
            if not WarningGiven then
            begin
              WarningGiven := True;
              MessageDlg('Warning: The MF_Layer function gives incorrect '
                + 'results when copying contours to the clipboard and in '
                + 'certain other operations.  You are being shown this message '
                + 'because the MF_Layer function could not operate properly. '
                + 'You will not be shown this message again so long as Argus '
                + 'ONE remains open.  However, you will still hear a beep when '
                + 'the problem occurs.', mtError, [mbOK], 0);
            end;
{          end;  }
        end;

      end;
    end;
    finally
      begin
        if not DontUpdateForm then
        begin
          EditWindowOpen := False;
        end;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

end.
