unit frmDataLayerNameUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, AnePIE, ArgusFormUnit;

type
  TfrmDataLayerName = class(TArgusForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    comboDataLayer: TComboBox;
    Label2: TLabel;
    BitBtn3: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure edDataLayerNameChange(Sender: TObject);
    procedure comboDataLayerChange(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
  private
    procedure AssignHelpFile(FileName: string);
    { Private declarations }
  public
    OK : boolean;
    LayerHandle : ANE_PTR;
    procedure GetLayerNames;
    { Public declarations }
  end;

var
  frmDataLayerName: TfrmDataLayerName;

implementation

{$R *.DFM}

uses ANE_LayerUnit, FixNameUnit, ANECB, OptionsUnit, UtilityFunctions;

procedure TfrmDataLayerName.BitBtn2Click(Sender: TObject);
var
  LayerName : string;
  DataLayer : T_ANE_NamedDataLayer;
  LayerTemplate : String;
  LayerType : EPIELayerType;
  ANE_LayerTemplate : ANE_STR;
  An_ANE_STR : ANE_STR;
begin
  LayerName := FixArgusName(comboDataLayer.Text);
  LayerHandle := GetLayerHandle(CurrentModelHandle, LayerName);
{  GetMem(An_ANE_STR, Length(LayerName) + 1);
  try
    StrPCopy(An_ANE_STR,LayerName);
    LayerHandle := ANE_LayerGetHandleByName(CurrentModelHandle, An_ANE_STR);
  finally
    FreeMem(An_ANE_STR);
  end;  }
  if LayerHandle = nil then
  begin
    DataLayer := T_ANE_NamedDataLayer.Create(LayerName, nil , -1);
    try
      LayerTemplate := DataLayer.WriteLayer(CurrentModelHandle);
      GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
      try
        StrPCopy(ANE_LayerTemplate, LayerTemplate);
        LayerHandle := ANE_LayerAddByTemplate(CurrentModelHandle,
          ANE_LayerTemplate,nil);
      finally
        FreeMem(ANE_LayerTemplate);
      end;
    finally
      DataLayer.Free;
    end;
  end
  else
  begin
    LayerType := ANE_LayerGetType (CurrentModelHandle,LayerHandle);
    if LayerType <> kPIEDataLayer then
    begin
      LayerHandle := nil;
      Beep;
      MessageDlg(LayerName + ' already exist but it is not a data layer.', mtError, [mbOK], 0);
    end;
  end;
  OK := (LayerHandle <> nil);

end;

procedure TfrmDataLayerName.edDataLayerNameChange(Sender: TObject);
var
  ValidName : String;
begin
  inherited;
  ValidName := FixArgusName(comboDataLayer.Text);
  if comboDataLayer.Text <> ValidName then
  begin
    comboDataLayer.Text := ValidName;
  end;
end;

procedure TfrmDataLayerName.GetLayerNames;
var
  ProjectOptions : TProjectOptions;
begin
  inherited;
  ProjectOptions := TProjectOptions.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle, [pieDataLayer],
      comboDataLayer.Items);
  finally
    ProjectOptions.Free;
  end;

end;

procedure TfrmDataLayerName.comboDataLayerChange(Sender: TObject);
var
  ValidName : String;
begin
  inherited;
  ValidName := FixArgusName(comboDataLayer.Text);
  if comboDataLayer.Text <> ValidName then
  begin
    comboDataLayer.Text := ValidName;
  end;

end;

procedure TfrmDataLayerName.FormCreate(Sender: TObject);
begin
  inherited;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  AssignHelpFile('EditDataLayer.hlp');
end;

procedure TfrmDataLayerName.AssignHelpFile(FileName : string);
var
    DllDirectory : String;
begin
  // called by FormHelp

  // This procedure assigns the proper help file to the application.
  // It may be overridden in descendent classes.
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      HelpFile := DllDirectory + '\' + FileName; // MODFLOW.hlp';
    end
  else
    begin
      Beep;
      ShowMessage(DLLName + ' not found.');
    end;
end;

end.
