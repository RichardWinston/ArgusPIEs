unit LayerNamePrompt;

interface

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

begin
  LayerIndex := 0;
  while LayerHandle <> nil do
  begin
    Inc( LayerIndex);
    LayerName := ALayerType.ANE_LayerName +
      IntToStr(LayerIndex) ;
    LayerHandle := ANE_LayerGetHandleByName(anehandle,
      PChar(LayerName)  );
  end;
  frmLayerNamePrompt := TfrmLayerNamePrompt.Create(Application);
  try
    frmLayerNamePrompt.lblLayerName.Caption := ALayerType.ANE_LayerName;
    frmLayerNamePrompt.EdNewName.Text
      := ALayerType.ANE_LayerName + IntToStr(LayerIndex);

    frmLayerNamePrompt.rgAnswer.ItemIndex := UserResponse;


    frmLayerNamePrompt.ShowModal;
    if frmLayerNamePrompt.rgAnswer.ItemIndex = 0 then
    begin
      LayerName := ALayerType.ANE_LayerName ;
      LayerHandle := ANE_LayerGetHandleByName(anehandle,
        PChar(LayerName)  );
    end
    else
    begin
      LayerName
        := FixArgusName(frmLayerNamePrompt.EdNewName.Text);
      LayerHandle := ANE_LayerGetHandleByName(anehandle,
        PChar(LayerName));
      if LayerHandle = nil then
      begin
        ALayer := ALayerType.Create(ALayerList, -1);
        try
          ALayer.DataIndex := LayerIndex;
          LayerTemplate := ALayer.WriteLayer(anehandle);
          PreviousLayerHandle := nil; // if the previous layer is not
          // set to nil there is an access violation if the new data
          // layer is not the last layer.
          LayerHandle := ANE_LayerAddByTemplate(anehandle,
             PChar(LayerTemplate),
             PreviousLayerHandle );
          if (ALayer.WriteSpecialBeginning
            + ALayer.ANE_LayerName
            + ALayer.WriteSpecialMiddle
            + ALayer.WriteIndex
            + ALayer.WriteSpecialEnd
            <> FixArgusName(frmLayerNamePrompt.EdNewName.Text)) then
          begin
            ANE_LayerRename(anehandle, LayerHandle,
              PChar(FixArgusName(frmLayerNamePrompt.EdNewName.Text)));
          end;

        finally
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
