unit RotationCalculator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ArgusDataEntry, AnePIE, Buttons;

type
  TfrmRotation = class(TForm)
    adeHST3DX: TArgusDataEntry;
    adeHST3DY: TArgusDataEntry;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    adeArgusX: TArgusDataEntry;
    adeArgusY: TArgusDataEntry;
    Label5: TLabel;
    btnCalc: TButton;
    btnClose: TBitBtn;
    adeColumn: TArgusDataEntry;
    adeRow: TArgusDataEntry;
    Label6: TLabel;
    Label7: TLabel;
    procedure btnCalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure CalculateCoordinate(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
var
  frmRotation: TfrmRotation;

implementation

uses ANECB, HST3DGridLayer, ANE_LayerUnit, HST3D_PIE_Unit, UtilityFunctions ;

{$R *.DFM}

procedure TfrmRotation.btnCalcClick(Sender: TObject);
var
  gridLayerHandle :ANE_PTR ;
  Angle, CosAngle, SinAngle : double;
  RowPositon, ColPostion : ANE_DOUBLE;
  StringToEvaluate: string;
  HST3DX, HST3DY : double;
  ColIndex, RowIndex : integer;
  NumRows, NumCol : integer;
  distance, currentDistance : double;
  RotatedX, RotatedY : double;
  Row, Column : integer;
begin
  adeArgusX.Enabled := True;
  adeArgusY.Enabled := True;
  adeColumn.Enabled := True;
  adeRow.Enabled := True;

  gridLayerHandle := ANE_LayerGetHandleByName(PIE_Data.HST3DForm.CurrentModelHandle,
    PChar(THST3DGridLayer.ANE_LayerName)  );


  ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, gridLayerHandle,
      kPIEFloat, 'If(IsNA(GridAngle()), 0.0, GridAngle())', @Angle);

  CosAngle := Cos(Angle);
  SinAngle := Sin(Angle);

  HST3DX := LocalStrToFloat(adeHST3DX.Text);
  HST3DY := LocalStrToFloat(adeHST3DY.Text);

  StringToEvaluate := 'NumRows()';

  ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, gridLayerHandle,
      kPIEInteger, PChar(StringToEvaluate), @NumRows);

  StringToEvaluate := 'NumColumns()';

  ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, gridLayerHandle,
      kPIEInteger, PChar(StringToEvaluate), @NumCol);



  StringToEvaluate := 'If(IsNA(NthColumnPos(0)), 0.0, NthColumnPos(0))';

    ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, gridLayerHandle,
        kPIEFloat, PChar(StringToEvaluate), @ColPostion);

  distance := abs(HST3DX - ColPostion);

  For ColIndex := 1 to NumCol do
  begin
    StringToEvaluate := 'If(IsNA(NthColumnPos(' + IntToStr(ColIndex)
      + ')), 0.0, NthColumnPos(' + IntToStr(ColIndex) + '))';

    ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, gridLayerHandle,
        kPIEFloat, PChar(StringToEvaluate), @ColPostion);

    currentDistance := abs(HST3DX - ColPostion);
    if currentDistance < distance
    then
      begin
        distance := currentDistance;
        RotatedX := ColPostion;
      end
    else
      begin
        Column := ColIndex - 1;
        break;
      end;

  end;

  StringToEvaluate := 'If(IsNA(NthRowPos(0)), 0.0, NthRowPos(0))';

    ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, gridLayerHandle,
        kPIEFloat, PChar(StringToEvaluate), @RowPositon);

  distance := abs(HST3DY - RowPositon);

  For RowIndex := 1 to NumRows do
  begin
    StringToEvaluate := 'If(IsNA(NthRowPos(' + IntToStr(RowIndex)
      + ')), 0.0, NthRowPos(' + IntToStr(RowIndex) + '))';

    ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, gridLayerHandle,
        kPIEFloat, PChar(StringToEvaluate), @RowPositon);

    currentDistance := abs(HST3DY - RowPositon);
    if currentDistance < distance
    then
      begin
        distance := currentDistance;
        RotatedY := RowPositon;
      end
    else
      begin
        Row := RowIndex - 1;
        break;
      end;

  end;

  if Angle = 0
  then
    begin
      adeArgusX.Text := FloatToStr(RotatedX);
      adeArgusY.Text := FloatToStr(RotatedY);
    end
  else
    begin
      adeArgusX.Text := FloatToStr(RotatedX*CosAngle - RotatedY*SinAngle);
      adeArgusY.Text := FloatToStr(RotatedX*SinAngle + RotatedY*CosAngle);
    end;

  adeColumn.Text := FloatToStr(Column);
  adeRow.Text := FloatToStr(Row);



end;

procedure CalculateCoordinate(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
begin
  if EditWindowOpen
  then
    begin
//      result := False;
    end
  else
    begin
      EditWindowOpen := True;
      try
        begin
        //  CurrentModelHandle := aneHandle;
          ANE_GetPIEProjectHandle(aneHandle, @PIE_Data );
          PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
          if PIE_Data.HST3DForm.frmRotation = nil then
          begin
            PIE_Data.HST3DForm.frmRotation := TfrmRotation.Create(PIE_Data.HST3DForm);
          end;
        //  CurrentModelHandle := aneHandle;
          try
            begin
              PIE_Data.HST3DForm.frmRotation.ShowModal;
            end;
          except on Exception do
            begin
        //      frmRotation.Free;
            end;
          end;
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end;
    end;
end;

end.
