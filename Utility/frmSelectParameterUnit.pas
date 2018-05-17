unit frmSelectParameterUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, siComboBox, AnePIE;

type
  TfrmSelectParameter = class(TForm)
    sicomboParameters: TsiComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
  private
    { Private declarations }
  public
    procedure GetParameters(const CurrentModelHandle, LayerHandle : ANE_PTR);
    { Public declarations }
  end;

function SelectParameter(const CurrentModelHandle, LayerHandle: ANE_PTR) : Integer;

var
  frmSelectParameter: TfrmSelectParameter;

implementation

uses OptionsUnit;

{$R *.DFM}

{ TfrmSelectParameter }

procedure TfrmSelectParameter.GetParameters(const CurrentModelHandle,
  LayerHandle: ANE_PTR);
var
  Layer : TLayerOptions;
  ParamIndex : ANE_INT32;
  NewWidth, TestWidth : integer;
  Parameter : TParameterOptions;
begin
  Layer := TLayerOptions.Create(LayerHandle);
  try
    Layer.GetParameterNames(CurrentModelHandle, sicomboParameters.Items);
    for ParamIndex := sicomboParameters.Items.Count -1 downto 0 do
    begin
      Parameter := TParameterOptions.Create(LayerHandle, ParamIndex);
      try
        if Parameter.NumberType[CurrentModelHandle] <> pnFloat then
        begin
          sicomboParameters.Items.Delete(ParamIndex);
        end;
      finally
        Parameter.Free;
      end;
    end;

    NewWidth := sicomboParameters.Width;
    for ParamIndex := 0 to sicomboParameters.Items.Count -1 do
    begin
      TestWidth := Canvas.TextWidth(sicomboParameters.Items[ParamIndex]);
      if TestWidth > NewWidth then
      begin
        NewWidth := TestWidth;
      end;
    end;
    if NewWidth > sicomboParameters.Width then
    begin
      sicomboParameters.CWX := NewWidth - sicomboParameters.Width;
    end;
    if sicomboParameters.Items.Count > 0 then
    begin
      sicomboParameters.ItemIndex := 0;
    end;
  finally
    Layer.Free(CurrentModelHandle);
  end;
end;

function SelectParameter(const CurrentModelHandle, LayerHandle: ANE_PTR) : Integer;
begin
  Application.CreateForm(TfrmSelectParameter, frmSelectParameter);
  try
    frmSelectParameter.GetParameters(CurrentModelHandle, LayerHandle);
    if frmSelectParameter.sicomboParameters.Items.Count = 0 then
    begin
      Beep;
      MessageDlg('Error: There are no real number parameters on this layer.',
        mtError, [mbOK], 0);
      result := -1;
    end
    else
    begin
      if frmSelectParameter.ShowModal = mrOK then
      begin
        result := frmSelectParameter.sicomboParameters.ItemIndex;
      end
      else
      begin
        result := -1;
      end;
    end
  finally
    frmSelectParameter.Free;
  end;
end;

end.
