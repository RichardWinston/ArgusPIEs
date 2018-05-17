unit frmAddParametersUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RzLstBox, RzChkLst, AnePIE;

type
  TfrmAddParameters = class(TForm)
    rzclLayerNames: TRzCheckList;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    edParamName: TEdit;
    Name: TLabel;
    comboValueType: TComboBox;
    edValue: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edUnits: TEdit;
    BitBtn3: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    procedure GetLayers;
    { Public declarations }
  end;

var
  frmAddParameters: TfrmAddParameters;

implementation

uses ANECB, OptionsUnit, ANE_LayerUnit, FixNameUnit, UtilityFunctions;

{$R *.DFM}

type
  TValueNamedLayerParam = class(T_ANE_NamedLayerParam)
  public
    function Value : string; override;
    function Units : string; override;
  end;

procedure TfrmAddParameters.GetLayers;
var
  ProjectOptions : TProjectOptions;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle,
      [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
        pieGridLayer,pieDataLayer,pieDomainLayer],rzclLayerNames.Items);
  finally
    ProjectOptions.Free;
  end;

end;

procedure TfrmAddParameters.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmAddParameters.BitBtn1Click(Sender: TObject);
var
  Param : TValueNamedLayerParam;
  Layer : T_ANE_NamedInfoLayer;
  LayerOption : TLayerOptions;
  Index : integer;
  ParamName : string;
begin
  if edParamName.Text = '' then
  begin
    Beep;
    MessageDlg('You must specify the name of the parameter',
      mtWarning, [mbOK], 0);
    ModalResult := mrNone;
  end
  else
  begin
    ParamName := FixArgusName(edParamName.Text);
    for Index := 0 to rzclLayerNames.Items.Count -1 do
    begin
      if rzclLayerNames.ItemChecked[Index] then
      begin
        Layer := T_ANE_NamedInfoLayer.Create(
          rzclLayerNames.Items[Index], nil, -1);
        LayerOption := TLayerOptions.CreateWithName(rzclLayerNames.Items[Index],
          CurrentModelHandle);
        try
          Param := TValueNamedLayerParam.Create(ParamName,
            Layer.ParamList, -1);
          if LayerOption.LayerType[CurrentModelHandle] = pieDataLayer then
          begin
            Param.ValueType := pvReal;
          end
          else
          begin
            Param.ValueType := TParameterValueType(comboValueType.ItemIndex);
          end;
          Param.Lock := [];
          Layer.AddNewParameters(CurrentModelHandle);
        finally
          Layer.Free;
          LayerOption.Free(CurrentModelHandle);
        end;
      end;
    end;
  end;
end;

procedure TfrmAddParameters.FormCreate(Sender: TObject);
var
  DllDirectory : String;
begin
  comboValueType.ItemIndex := 1;
  if GetDllDirectory(GetDLLName, DllDirectory) then
  begin
    HelpFile := DllDirectory + '\' + HelpFile;
  end;
end;

{ TValueNamedLayerParam }

function TValueNamedLayerParam.Units: string;
begin
  result := frmAddParameters.edUnits.Text;
end;

function TValueNamedLayerParam.Value: string;
begin
  result := frmAddParameters.edValue.Text;
end;

end.
