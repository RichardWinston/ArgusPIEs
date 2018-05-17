unit CreateObsGridUnit;

interface

uses AnePIE, sysutils, Dialogs, classes;

function CreateObservationGrid (aneHandle : ANE_PTR;
   const  fileName : ANE_STR;  layerHandle : ANE_PTR) : ANE_BOOL ; cdecl;

implementation

uses HST3DGridLayer, ANECB;

function CreateObservationGrid (aneHandle : ANE_PTR;
   const  fileName : ANE_STR;  layerHandle : ANE_PTR) : ANE_BOOL ; cdecl;
const
  ErrorTolerance = 1e-8;
var
  MainGridLayerHandle : ANE_PTR;
  ObsGridLayerHandle : ANE_PTR;
  OK : boolean;
  NumRows, NumCol : integer;
  NewGridNumRows, NewGridNumCol : integer;
  StringToEvaluate : string;
  AStringList : TStringList;
  StringIndex : integer;
  GridString : string;
  GridAngle : ANE_DOUBLE;
  GridAngleString : String;
  Row0, Column0 : ANE_DOUBLE;
  GridRowOrigin, GridColumnOrigin : ANE_DOUBLE;
  AngleToOrigin, DistanceToOrigin :Extended;
  RowIndex, ColumnIndex : integer;
  RowHeight, ColumnWidth  :ANE_DOUBLE;
  NewGridPosition, OldGridPosition :ANE_DOUBLE;
  Denoninator :ANE_DOUBLE;

begin
  result := False;
  try
    begin
      OK := True;
      MainGridLayerHandle := ANE_LayerGetHandleByName(aneHandle,
         PChar(THST3DGridLayer.ANE_LayerName) );

      ObsGridLayerHandle := ANE_LayerGetHandleByName(aneHandle,
         PChar(THST3DNodeGridLayer.ANE_LayerName) );

      if MainGridLayerHandle = nil then
      begin
        OK := False;
        MessageDlg(THST3DGridLayer.ANE_LayerName + ' layer not found', mtError, [mbOK], 0);
      end;

      if OK and (ObsGridLayerHandle = nil) then
      begin
        OK := False;
        MessageDlg(THST3DNodeGridLayer.ANE_LayerName + ' layer not found', mtError, [mbOK], 0);
      end;

      if OK then
      begin
        StringToEvaluate := 'NumRows()';

        ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
            kPIEInteger, PChar(StringToEvaluate), @NumRows);

        StringToEvaluate := 'NumColumns()';

        ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
            kPIEInteger, PChar(StringToEvaluate), @NumCol);

        if (NumRows <= 0) or (NumCol <= 0) then
        begin
          OK := False;
          MessageDlg('No Grid on ' + THST3DGridLayer.ANE_LayerName + ' layer.', mtError, [mbOK], 0);
        end;
      end;


      if OK then
      begin
        ANE_LayerClear(aneHandle, ObsGridLayerHandle, False);

        ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
          kPIEFloat,
          'If(IsNA(GridAngle()), 0.0, GridAngle())', @GridAngle);

        GridAngleString := FloatToStr(GridAngle * 180 / Pi);

        ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
          kPIEFloat, 'NthRowPos(0)', @Row0);

        ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
          kPIEFloat, 'NthColumnPos(0)', @Column0);

        if Column0 = 0 then
        begin
          if Row0 < 0 then
          begin
            AngleToOrigin := -Pi/2
          end
          else
          begin
            AngleToOrigin := Pi/2
          end;
        end
        else
        begin
          AngleToOrigin :=  ArcTan(Row0/Column0);
          if Column0 < 0 then
          begin
            AngleToOrigin := AngleToOrigin + Pi;
          end;
        end;
        DistanceToOrigin := Sqrt(Sqr(Row0) + Sqr(Column0));
        AngleToOrigin := AngleToOrigin + GridAngle;

        GridRowOrigin := DistanceToOrigin * Sin(AngleToOrigin);
        GridColumnOrigin := DistanceToOrigin * Cos(AngleToOrigin);

        AStringList := TStringList.Create;
        try
          begin
            AStringList.Add(IntToStr(NumRows + 1) + ' ' + IntToStr(NumCol + 1)
              + ' 0 ' + GridAngleString);

            AStringList.Add(FloatToStr(GridRowOrigin));

            For RowIndex := 0 to NumRows-1 do
            begin
              StringToEvaluate := 'NthRowHeight(' + IntToStr(RowIndex) + ')';

              ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
                    kPIEFloat, PChar(StringToEvaluate), @RowHeight);

              AStringList.Add(FloatToStr(RowHeight));

            end;

            AStringList.Add(FloatToStr(GridColumnOrigin));

            For ColumnIndex := 0 to NumCol-1 do
            begin
              StringToEvaluate := 'NthColumnWidth(' + IntToStr(ColumnIndex) + ')';

              ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
                    kPIEFloat, PChar(StringToEvaluate), @ColumnWidth);

              AStringList.Add(FloatToStr(ColumnWidth));

            end;

            GridString := '';
            For StringIndex := 0 to AStringList.Count -1  do
            begin
              GridString := GridString + AStringList.Strings[StringIndex] + Char(10);
            end;

            ANE_ImportTextToLayerByHandle(aneHandle, ObsGridLayerHandle,
              PChar(GridString));

            StringToEvaluate := 'NumRows()';

            ANE_EvaluateStringAtLayer(aneHandle, ObsGridLayerHandle,
                kPIEInteger, PChar(StringToEvaluate), @NewGridNumRows);

            StringToEvaluate := 'NumColumns()';

            ANE_EvaluateStringAtLayer(aneHandle, ObsGridLayerHandle,
                kPIEInteger, PChar(StringToEvaluate), @NewGridNumCol);

            if (NumRows +1 <> NewGridNumRows) or (NumCol +1 <> NewGridNumCol) then
            begin
              OK := False;
              MessageDlg(THST3DNodeGridLayer.ANE_LayerName +
                ' must be a Grid-Centered Grid.', mtError, [mbOK], 0);

              ANE_LayerClear(aneHandle, ObsGridLayerHandle, False);
            end;

          end;
        finally
          begin
            AStringList.Free;
          end;
        end;

        if OK then
        begin
          StringToEvaluate := 'NthColumnPos(0)';

          ANE_EvaluateStringAtLayer(aneHandle, ObsGridLayerHandle,
              kPIEFloat, PChar(StringToEvaluate), @NewGridPosition);

          StringToEvaluate := 'NthColumnPos(0)';

          ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
              kPIEFloat, PChar(StringToEvaluate), @OldGridPosition);

          Denoninator := OldGridPosition + NewGridPosition;
          if Denoninator = 0 then
          begin
            Denoninator := ErrorTolerance
          end;

          if (Abs(OldGridPosition - NewGridPosition)/Denoninator)
            > ErrorTolerance then
          begin
            OK := False;
            MessageDlg(THST3DNodeGridLayer.ANE_LayerName +
              ' must be a Grid-Centered Grid.', mtError, [mbOK], 0);

            ANE_LayerClear(aneHandle, ObsGridLayerHandle, False);
          end;
        end;

        if OK then
        begin
          StringToEvaluate := 'NthRowPos(0)';

          ANE_EvaluateStringAtLayer(aneHandle, ObsGridLayerHandle,
              kPIEFloat, PChar(StringToEvaluate), @NewGridPosition);

          StringToEvaluate := 'NthRowPos(0)';

          ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
              kPIEFloat, PChar(StringToEvaluate), @OldGridPosition);

          Denoninator := OldGridPosition + NewGridPosition;
          if Denoninator = 0 then
          begin
            Denoninator := ErrorTolerance
          end;

          if (Abs(OldGridPosition - NewGridPosition)/Denoninator)
            > ErrorTolerance then
          begin
            OK := False;
            MessageDlg(THST3DNodeGridLayer.ANE_LayerName +
              ' must be a Grid-Centered Grid.', mtError, [mbOK], 0);

            ANE_LayerClear(aneHandle, ObsGridLayerHandle, False);
          end;
        end;

        if OK then
        begin
          StringToEvaluate := 'NthColumnPos(' + IntToStr(NumCol) + ')';

          ANE_EvaluateStringAtLayer(aneHandle, ObsGridLayerHandle,
              kPIEFloat, PChar(StringToEvaluate), @NewGridPosition);

          StringToEvaluate := 'NthColumnPos(' + IntToStr(NewGridNumCol) + ')';

          ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
              kPIEFloat, PChar(StringToEvaluate), @OldGridPosition);

          Denoninator := OldGridPosition + NewGridPosition;
          if Denoninator = 0 then
          begin
            Denoninator := ErrorTolerance
          end;

          if (Abs(OldGridPosition - NewGridPosition)/Denoninator)
            > ErrorTolerance then
          begin
            OK := False;
            MessageDlg(THST3DNodeGridLayer.ANE_LayerName +
              ' must be a Grid-Centered Grid.', mtError, [mbOK], 0);

            ANE_LayerClear(aneHandle, ObsGridLayerHandle, False);
          end;
        end;

        if OK then
        begin
          StringToEvaluate := 'NthRowPos(' + IntToStr(NumRows) + ')';

          ANE_EvaluateStringAtLayer(aneHandle, ObsGridLayerHandle,
              kPIEFloat, PChar(StringToEvaluate), @NewGridPosition);

          StringToEvaluate := 'NthRowPos(' + IntToStr(NewGridNumRows) + ')';

          ANE_EvaluateStringAtLayer(aneHandle, MainGridLayerHandle,
              kPIEFloat, PChar(StringToEvaluate), @OldGridPosition);

          Denoninator := OldGridPosition + NewGridPosition;
          if Denoninator = 0 then
          begin
            Denoninator := ErrorTolerance
          end;

          if (Abs(OldGridPosition - NewGridPosition)/Denoninator)
            > ErrorTolerance then
          begin
            OK := False;
            MessageDlg(THST3DNodeGridLayer.ANE_LayerName +
              ' must be a Grid-Centered Grid.', mtError, [mbOK], 0);

            ANE_LayerClear(aneHandle, ObsGridLayerHandle, False);
          end;
        end;
        Result := OK
      end;
    end;
  except on Exception do
    begin
      MessageDlg('Unknown Exception', mtError, [mbOK], 0);
      result := False;
    end;
  end;


end;

end.
