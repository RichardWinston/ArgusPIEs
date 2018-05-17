unit frmProjectUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, Buttons, ArgusDataEntry, ANE_LayerUnit, Menus;

type
  TfrmProject = class(TArgusForm)
    ArgusDataEntry1: TArgusDataEntry;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    atest: TPopupMenu;
    test11: TMenuItem;
    test21: TMenuItem;
    procedure test11Click(Sender: TObject);
    procedure test21Click(Sender: TObject);
  private
    { Private declarations }
  public
    LayerStructure : TLayerStructure;
    { Public declarations }
    procedure ModelComponentName(AStringList: TStringList); override;
  end;

var
  frmProject: TfrmProject;

implementation

{$R *.DFM}

{ TfrmProject }

procedure TfrmProject.ModelComponentName(AStringList: TStringList);
begin
  inherited;

end;

procedure TfrmProject.test11Click(Sender: TObject);
var
  AString : string;
begin
  inherited;
  AString := 'You clicked Menu Item ';
  If Sender = test11 then
  begin
    AString := AString + '1.'
  end
  else
  begin
    AString := AString + '2.'
  end;
  ShowMessage(AString);
  ModalResult := mrOK;
end;

procedure TfrmProject.test21Click(Sender: TObject);
begin
  inherited;
  frmProject.ShowModal;
end;

end.
