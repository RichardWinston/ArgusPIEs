unit DefaultValueFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ArgusDataEntry, StringStorage, AnePIE, ANE_LayerUnit;

type
  TFrmDefaultValue = class(TFrame)
    btnSetValue: TButton;
    adeProperty: TArgusDataEntry;
    lblParameterName: TLabel;
    LayerClassName: TStringStorage;
    ParameterClassName: TStringStorage;
    procedure btnSetValueClick(Sender: TObject);
    procedure adePropertyChange(Sender: TObject);
  private
    OldValue: string;
    procedure SetFEnabled(const Value: boolean);
    function GetFEnabled : boolean;
    { Private declarations }
  public
    procedure SaveCurrentValue;
    procedure RestoreOldValue;
    Function GetLayerStructure : TLayerStructure;
    Function GetModelHandle : ANE_PTR;
    property Enabled : boolean read GetFEnabled write SetFEnabled;
    { Public declarations }
  published
  end;

implementation

{$R *.DFM}

uses
  OptionsUnit, frmSutraUnit;

{ TFrmDefaultValue }

function TFrmDefaultValue.GetLayerStructure: TLayerStructure;
var
  SutraForm : TfrmSutra;
  AnOwner : TComponent;
begin
  result := nil;
  AnOwner := Owner;
  While AnOwner <> nil do
  begin
    if AnOwner is TfrmSutra then
    begin
      SutraForm := AnOwner as TfrmSutra;
      result := SutraForm.SutraLayerStructure;
      Exit;
    end
    else
    begin
      AnOwner := AnOwner.Owner;
    end;
  end;
end;

procedure TFrmDefaultValue.btnSetValueClick(Sender: TObject);
var
  LayerStructure: TLayerStructure;
  LayerIndex : integer;
  AMapLayer : T_ANE_MapsLayer;
  ALayer : T_ANE_Layer;
  ClassName, ParameterName, ArgusParamName : string;
  AParam : T_ANE_Param;
//  SetValue : boolean;
  LayerHandle : ANE_PTR;
  ModelHandle : ANE_PTR;
  ParamOptions : TParameterOptions;
  LayerOptions : TLayerOptions;
  ArgusParamIndex : ANE_INT32;
  procedure SetThisValue;
  begin
    if (AMapLayer <> nil) and (AMapLayer  is T_ANE_Layer) and (AMapLayer.Status <> sNew) then
    begin
      ALayer := AMapLayer as T_ANE_Layer;
      LayerHandle := ALayer.GetLayerHandle(ModelHandle);
      LayerOptions := TLayerOptions.Create(LayerHandle);;
      try
        AParam := ALayer.ParamList.GetParameterByName(ParameterName);
        if AParam <> nil then
        begin
          ArgusParamName := AParam.OldName;
          ArgusParamIndex := LayerOptions.GetParameterIndex(ModelHandle, ArgusParamName);
          ParamOptions := TParameterOptions.Create(LayerHandle,ArgusParamIndex);
          try
            ParamOptions.Expr[ModelHandle] := adeProperty.Output;
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
  ClassName := LayerClassName.StringVariable;
  ParameterName := ParameterClassName.StringVariable;
  ModelHandle := GetModelHandle;
  if (ClassName <> '') and (ParameterName <> '') and (ModelHandle <> nil) then
  begin
    LayerStructure := GetLayerStructure;
    if LayerStructure <> nil then
    begin
      AMapLayer := LayerStructure.UnIndexedLayers.GetLayerByName(ClassName);
      SetThisValue;
      for LayerIndex := 0 to LayerStructure.ListsOfIndexedLayers.Count -1 do
      begin
        AMapLayer := LayerStructure.ListsOfIndexedLayers.Items[LayerIndex].
          GetLayerByName(ClassName);
        SetThisValue;
      end;
    end;
  end;
  if not (csLoading in frmSutra.ComponentState) then
  begin
    btnSetValue.Font.Style := btnSetValue.Font.Style - [fsBold];
  end;
end;

function TFrmDefaultValue.GetModelHandle: ANE_PTR;
var
  SutraForm : TfrmSutra;
  AnOwner: TComponent;
begin
  result := nil;
  AnOwner := Owner;
  While AnOwner <> nil do
  begin
    if AnOwner is TfrmSutra then
    begin
      SutraForm := AnOwner as TfrmSutra;
      result := SutraForm.CurrentModelHandle;
      Exit;
    end
    else
    begin
      AnOwner := AnOwner.Owner;
    end;
  end;
end;  

procedure TFrmDefaultValue.adePropertyChange(Sender: TObject);
begin
  if not (csLoading in ComponentState) and (frmSutra <> nil)
    and not (csLoading in frmSutra.ComponentState) then
  begin
    if not frmSutra.NewProject then
    begin
      btnSetValue.Font.Style := btnSetValue.Font.Style + [fsBold];
    end;
  end;
end;

procedure TFrmDefaultValue.SetFEnabled(const Value: boolean);
begin
  Inherited Enabled := Value;
  adeProperty.Enabled := Value;
end;

function TFrmDefaultValue.GetFEnabled: boolean;
begin
  result := inherited Enabled;
end;

procedure TFrmDefaultValue.RestoreOldValue;
begin
  adeProperty.Text := OldValue;
end;

procedure TFrmDefaultValue.SaveCurrentValue;
begin
  OldValue := adeProperty.Text;
end;

end.
