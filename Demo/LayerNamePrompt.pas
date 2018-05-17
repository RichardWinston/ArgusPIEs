unit LayerNamePrompt;

interface

{TfrmLayerNamePrompt is a form that is displayed when a layer already exists.
 GetValidLayer uses TfrmLayerNamePrompt to ask the user to choose how to handle
 this situation.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, AnePIE, ANE_LayerUnit;

type
  TfrmLayerNamePrompt = class(TForm)
    lblAlreadyExists: TLabel;
    rgAnswer: TRadioGroup;
    EdNewName: TEdit;
    BitBtn1: TBitBtn;
    lblLayerName: TLabel;
    lblNewName: TLabel;
    procedure rgAnswerClick(Sender: TObject);
  private
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED); message WM_WINDOWPOSCHANGED;
    { Public declarations }
  end;

var
  frmLayerNamePrompt: TfrmLayerNamePrompt;

procedure GetValidLayer(anehandle : ANE_PTR; var LayerHandle : ANE_PTR;
  ALayerType : T_ANE_MapsLayerClass; var LayerName : string;
  ALayerList: T_ANE_LayerList; var UserResponse : integer);

implementation

{$R *.DFM}

uses ANECB, FixNameUnit;

procedure TfrmLayerNamePrompt.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;    

procedure TfrmLayerNamePrompt.rgAnswerClick(Sender: TObject);
begin
  EdNewName.Enabled := (rgAnswer.ItemIndex = 1);
  if EdNewName.Enabled then
  begin
    EdNewName.Color := clWindow;
  end
  else
  begin
    EdNewName.Color := clBtnFace;
  end;
end;

procedure GetValidLayer(anehandle : ANE_PTR; var LayerHandle : ANE_PTR;
  ALayerType : T_ANE_MapsLayerClass; var LayerName : string;
  ALayerList: T_ANE_LayerList; var UserResponse : integer);
var
  LayerIndex : Integer;
  ALayer : T_ANE_MapsLayer;
  LayerTemplate : string;
  PreviousLayerHandle :ANE_PTR;
  OldName, NewName : string;
  OldNamePos : integer;
  ANE_LayerTemplate : ANE_STR;
  ANE_LayerNameStr : ANE_STR;
begin
  // initialize LayerIndex
  LayerIndex := 0;
  while LayerHandle <> nil do
  begin
    // update LayerIndex
    Inc( LayerIndex);
    // get the name of the first layer of this type that does not
    // exist.
    LayerName := ALayerType.ANE_LayerName +
      IntToStr(LayerIndex) ;
    LayerHandle := GetLayerHandle(anehandle,LayerName);
{    GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
    try
      StrPCopy(ANE_LayerNameStr, LayerName);
      LayerHandle := ANE_LayerGetHandleByName(anehandle,
        ANE_LayerNameStr);
    finally
      FreeMem(ANE_LayerNameStr);
    end;    }
  end;

  // create the LayerNamePrompt form.
//  frmLayerNamePrompt := TfrmLayerNamePrompt.Create(Application);
  Application.CreateForm(TfrmLayerNamePrompt, frmLayerNamePrompt);
  try
    frmLayerNamePrompt.Handle;
    frmLayerNamePrompt.EdNewName.Handle;
    frmLayerNamePrompt.BitBtn1.Handle;
    frmLayerNamePrompt.CurrentModelHandle := anehandle;
    // show the name of the layer in lblLayerName.Caption;
    frmLayerNamePrompt.lblLayerName.Caption := ALayerType.ANE_LayerName;

    // Show the name of the first valid name in EdNewName.Text
    frmLayerNamePrompt.EdNewName.Text := LayerName;

    // set the default response
    frmLayerNamePrompt.rgAnswer.ItemIndex := UserResponse;

    // show the LayerNamePrompt form.
    frmLayerNamePrompt.ShowModal;
    // determine the user's response.
    if frmLayerNamePrompt.rgAnswer.ItemIndex = 0 then
    begin
      // user has chosen to overwrite the existing layer so get its handle
      LayerName := ALayerType.ANE_LayerName ;
      LayerHandle := GetLayerHandle(anehandle,LayerName);
{      GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
      try
        StrPCopy(ANE_LayerNameStr, LayerName);
        LayerHandle := ANE_LayerGetHandleByName(anehandle,
          ANE_LayerNameStr);
      finally
        FreeMem(ANE_LayerNameStr);
      end;  }
    end
    else
    begin
      // user has chosen to create a new layer.

      // fix the name of the layer to remove invalid characters.
      LayerName
        := FixArgusName(frmLayerNamePrompt.EdNewName.Text);

      // get the handle for the layer.
      LayerHandle := GetLayerHandle(anehandle,LayerName);
{      GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
      try
        StrPCopy(ANE_LayerNameStr, LayerName);
        LayerHandle := ANE_LayerGetHandleByName(anehandle,
          ANE_LayerNameStr);
      finally
        FreeMem(ANE_LayerNameStr);
      end;}

      // if the layer doesn't already exist, create it.
      if LayerHandle = nil then
      begin
        ALayer := ALayerType.Create(ALayerList, -1);
        try
          ALayer.DataIndex := LayerIndex;
          LayerTemplate := ALayer.WriteLayer(anehandle);

          // if the default name for the layer is not what the user chose,
          // rename the layer.
          OldName := ALayer.WriteSpecialBeginning
            + ALayer.WriteNewRoot
            + ALayer.WriteSpecialMiddle
            + ALayer.WriteIndex
            + ALayer.WriteSpecialEnd;

          NewName := FixArgusName(frmLayerNamePrompt.EdNewName.Text);
          if OldName <> NewName then
          begin
            OldNamePos := Pos(OldName,LayerTemplate);
            assert(OldNamePos > 0);
            LayerTemplate := Copy(LayerTemplate,1,OldNamePos-1)
              + NewName
              + Copy(LayerTemplate, OldNamePos + Length(OldName), Length(LayerTemplate));
          end;

          PreviousLayerHandle := nil; // if the previous layer is not
          // set to nil there is an access violation if the new data
          // layer is not the last layer.
          GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
          try
            StrPCopy(ANE_LayerTemplate, LayerTemplate);
            LayerHandle := ANE_LayerAddByTemplate(anehandle,
               ANE_LayerTemplate, PreviousLayerHandle );
          finally
            FreeMem(ANE_LayerTemplate);
          end;

        finally
          // get rid of the representation of the layer in the PIE
          ALayer.Free;
        end;
      end;
    end;


  finally
    UserResponse := frmLayerNamePrompt.rgAnswer.ItemIndex;
    frmLayerNamePrompt.Free;

  end;
end;

end.
