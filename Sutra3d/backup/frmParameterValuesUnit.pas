unit frmParameterValuesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, Buttons, StdCtrls, ArgusDataEntry, ExtCtrls,
  DefaultValueFrame, AnePIE;

type
  TfrmParameterValues = class(TArgusForm)
    GroupBox5: TGroupBox;
    FramDMaxHydCond: TFrmDefaultValue;
    FramDMinHydCond: TFrmDefaultValue;
    FramLongDispMax: TFrmDefaultValue;
    FramLongDispMin: TFrmDefaultValue;
    FramTransvDispMax: TFrmDefaultValue;
    FramTransvDispMin: TFrmDefaultValue;
    FramPor: TFrmDefaultValue;
    FramInitTempConc: TFrmDefaultValue;
    FramPermAngleXY: TFrmDefaultValue;
    FramInitPres: TFrmDefaultValue;
    Panel4: TPanel;
    Label123: TLabel;
    adeThickness: TArgusDataEntry;
    btnSetThicknessValue: TButton;
    FramDMidHydCond: TFrmDefaultValue;
    FramPermAngleRotational: TFrmDefaultValue;
    FramPermAngleVertical: TFrmDefaultValue;
    FramLongDispMid: TFrmDefaultValue;
    FramTransvDisp1Mid: TFrmDefaultValue;
    Panel1: TPanel;
    btnDone: TBitBtn;
    btnSetAll: TButton;
    procedure btnDoneClick(Sender: TObject);
    procedure btnSetThicknessValueClick(Sender: TObject);
    procedure adeThicknessChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSetAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FramDMaxHydCondadePropertyChange(Sender: TObject);
  private
    OldThicknessValue: string;
    function QuickSetCheck: boolean;
    procedure ResetFonts;
    procedure EnableButtons;
    procedure FillButtonList(const List: TList);
    { Private declarations }
  public
    Procedure SaveCurrentValues;
    { Public declarations }
  end;

procedure GSetParameters(aneHandle : ANE_PTR; const  fileName : ANE_STR;
  layerHandle : ANE_PTR) ; cdecl;

implementation

uses SLThickness, frmSutraUnit, ANE_LayerUnit, OptionsUnit;

{$R *.DFM}

{ TfrmParameterValues }

procedure TfrmParameterValues.EnableButtons;
var
  List: TList;
  Index: integer;
  Item: TFrmDefaultValue;
begin
  if FrmSutra.NewProject then Exit;
  List := TList.Create;
  try
    List.Add(FramDMaxHydCond);
    List.Add(FramDMidHydCond);
    List.Add(FramDMinHydCond);

    List.Add(FramPermAngleXY);
    List.Add(FramPermAngleVertical);
    List.Add(FramPermAngleRotational);

    List.Add(FramPor);
    List.Add(FramInitPres);
    List.Add(FramInitTempConc);


    List.Add(FramLongDispMax);
    List.Add(FramLongDispMid);
    List.Add(FramLongDispMin);

    List.Add(FramTransvDispMax);
    List.Add(FramTransvDisp1Mid);
    List.Add(FramTransvDispMin);

//    List.Add(btnSetThicknessValue);


    for Index := 0 to List.Count -1 do
    begin
      Item := List[Index];
      Item.btnSetValue.Enabled := Item.adeProperty.Enabled
    end;

    btnSetThicknessValue.Enabled :=  adeThickness.Enabled;

  finally
    List.Free;
  end;
end;

function TfrmParameterValues.QuickSetCheck: boolean;
var
  List: TList;
  Index: integer;
  Button: TButton;
begin
  result := False;
  List := TList.Create;
  try
    FillButtonList(List);
    for Index := 0 to List.Count -1 do
    begin
      Button := List[Index];
      result := Button.Enabled and (fsBold in Button.Font.Style);
      if result then Exit;
    end;

  finally
    List.Free;
  end;
end;

procedure TfrmParameterValues.FillButtonList(const List: TList);
begin
  List.Add(FramDMaxHydCond.btnSetValue);
  List.Add(FramDMidHydCond.btnSetValue);
  List.Add(FramDMinHydCond.btnSetValue);

  List.Add(FramPermAngleXY.btnSetValue);
  List.Add(FramPermAngleVertical.btnSetValue);
  List.Add(FramPermAngleRotational.btnSetValue);

  List.Add(FramPor.btnSetValue);
  List.Add(btnSetThicknessValue);
  List.Add(FramInitPres.btnSetValue);
  List.Add(FramInitTempConc.btnSetValue);


  List.Add(FramLongDispMax.btnSetValue);
  List.Add(FramLongDispMid.btnSetValue);
  List.Add(FramLongDispMin.btnSetValue);

  List.Add(FramTransvDispMax.btnSetValue);
  List.Add(FramTransvDisp1Mid.btnSetValue);
  List.Add(FramTransvDispMin.btnSetValue);

end;

procedure TfrmParameterValues.ResetFonts;
var
  List: TList;
  Index: integer;
  Button: TButton;
  frame: TFrmDefaultValue;
begin
  List := TList.Create;
  try
    FillButtonList(List);
    for Index := 0 to List.Count -1 do
    begin
      Button := List[Index];
      if Button.Enabled and (fsBold in Button.Font.Style) then
      begin
        if Button.Parent is TFrmDefaultValue then
        begin
          frame := Button.Parent as TFrmDefaultValue;
          frame.RestoreOldValue;
        end
        else
        begin
          adeThickness.Text := OldThicknessValue;
        end;
        Button.Font.Style := Button.Font.Style - [fsBold];
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TfrmParameterValues.btnDoneClick(Sender: TObject);
begin
  inherited;
  if QuickSetCheck then
  begin
    Beep;
    if MessageDlg('You have changed values in one or more of the edit boxes '
      + 'but you have not clicked the button to '
      + 'actually set the value.'#10#13#10#13'Do you want a chance to '
      + 'click the button(s) to set these values?', mtWarning, [mbYes, mbNo], 0)
      = mrYes then
    begin
      Exit;
    end
    else
    begin
      ResetFonts;
    end;
  end;
  Close;
end;

procedure TfrmParameterValues.btnSetThicknessValueClick(Sender: TObject);
var
  LayerStructure: TLayerStructure;
  AMapLayer: T_ANE_MapsLayer;
  ALayer: T_ANE_Layer;
  ClassName, ParameterName, ArgusParamName: string;
  AParam: T_ANE_Param;
  LayerHandle: ANE_PTR;
  ModelHandle: ANE_PTR;
  ParamOptions: TParameterOptions;
  LayerOptions: TLayerOptions;
  ArgusParamIndex: ANE_INT32;
  procedure SetThisValue;
  begin
    if (AMapLayer <> nil) and (AMapLayer is T_ANE_Layer) and (AMapLayer.Status
      <> sNew) then
    begin
      ALayer := AMapLayer as T_ANE_Layer;
      LayerHandle := ALayer.GetLayerHandle(ModelHandle);
      LayerOptions := TLayerOptions.Create(LayerHandle);
      ;
      try
        AParam := ALayer.ParamList.GetParameterByName(ParameterName);
        if AParam <> nil then
        begin
          ArgusParamName := AParam.OldName;
          ArgusParamIndex := LayerOptions.GetParameterIndex(ModelHandle,
            ArgusParamName);
          ParamOptions := TParameterOptions.Create(LayerHandle,
            ArgusParamIndex);
          try
            ParamOptions.Expr[ModelHandle] := adeThickness.Output;
          finally
            ParamOptions.Free;
          end;
        end;
      finally
        LayerOptions.Free(ModelHandle);
      end;
    end;
  end;
begin
  inherited;
  ClassName := TThicknessLayer.ANE_LayerName;
  ParameterName := TThicknessParam.ANE_ParamName;
  ModelHandle := CurrentModelHandle;
  if (ClassName <> '') and (ParameterName <> '') and (ModelHandle <> nil) then
  begin
    LayerStructure := frmSutra.SutraLayerStructure;
    if LayerStructure <> nil then
    begin
      AMapLayer := LayerStructure.UnIndexedLayers.GetLayerByName(ClassName);
      SetThisValue;
    end;
  end;
  if not (csLoading in frmSutra.ComponentState) then
  begin
    btnSetThicknessValue.Font.Style := btnSetThicknessValue.Font.Style -
      [fsBold];
  end;
end;

procedure TfrmParameterValues.adeThicknessChange(Sender: TObject);
begin
  inherited;
  if not (csLoading in ComponentState) and (frmSutra <> nil)
    and not (csLoading in frmSutra.ComponentState) then
  begin
    if not frmSutra.NewProject then
    begin
      btnSetThicknessValue.Font.Style := btnSetThicknessValue.Font.Style +
        [fsBold];
    end;
    frmSutra.adeThickness.Text := adeThickness.Text;
  end;
end;

procedure TfrmParameterValues.FormShow(Sender: TObject);
begin
  inherited;
  EnableButtons;
end;

procedure TfrmParameterValues.btnSetAllClick(Sender: TObject);
var
  List: TList;
  Index: integer;
  Button: TButton;
begin
  inherited;
  List := TList.Create;
  try
    FillButtonList(List);
    for Index := 0 to List.Count -1 do
    begin
      Button := List[Index];
      if Button.Enabled and (fsBold in Button.Font.Style) then
      begin
        if Assigned(Button.OnClick) then
        begin
          Button.OnClick(Button);
        end;
      end;
    end;
  finally
    List.Free;
  end;

end;

procedure GSetParameters(aneHandle : ANE_PTR; const  fileName : ANE_STR;
  layerHandle : ANE_PTR) ; cdecl;
begin
  // Check that another model doesn't have a dialog box open. If it does,
  // prevent this one from openning because that would corrupt the data
  // for the other model.
  if EditWindowOpen
  then
  begin
    // Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    // make sure the project options used in exporting data are set correctly.
    try  // try 1
      begin
        Try
          begin
            frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
              as TfrmSutra;
            frmSutra.CurrentModelHandle := aneHandle;
            frmSutra.frmParameterValues.CurrentModelHandle := aneHandle;
            frmSutra.NewProject := False;
            frmSutra.frmParameterValues.ShowModal;
          end
        except on E: Exception do
          begin
            Beep;
            MessageDlg(E.Message, mtError, [mbOK], 0);
          end;
        end;
      end;
    finally
        EditWindowOpen := False;
    end; // try 1
  end; // if EditWindowOpen else
//  returnTemplate^ := Template;
end;



procedure TfrmParameterValues.FormCreate(Sender: TObject);
begin
  inherited;
  Constraints.MinWidth := Width;
  Constraints.MinHeight := Height;
end;

procedure TfrmParameterValues.FramDMaxHydCondadePropertyChange(
  Sender: TObject);
var
  Frame, OtherFrame: TFrmDefaultValue;
begin
  inherited;
  Frame := (Sender as TControl).Parent as TFrmDefaultValue;
  Frame.adePropertyChange(Sender);
  OtherFrame := frmSutra.FindComponent(Frame.Name) as TFrmDefaultValue;
  OtherFrame.adeProperty.Text := Frame.adeProperty.Text;
end;

procedure TfrmParameterValues.SaveCurrentValues;
var
  Index: integer;
  frame: TFrmDefaultValue;
begin
  OldThicknessValue := adeThickness.Text;
  for Index := 0 to ComponentCount -1 do
  begin
    if Components[Index] is TFrmDefaultValue then
    begin
      frame := Components[Index] as TFrmDefaultValue;
      frame.SaveCurrentValue;
    end;
  end;
end;

end.
