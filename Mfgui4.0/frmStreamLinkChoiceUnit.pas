unit frmStreamLinkChoiceUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, Buttons, ExtCtrls;

type
  TStreamPackageChoice = (spcSTR, spcSFR);

  TfrmStreamLinkChoice = class(TArgusForm)
    rgChoice: TRadioGroup;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStreamLinkChoice: TfrmStreamLinkChoice;

function StreamPackageChoice: TStreamPackageChoice;

implementation

uses Variables;

function StreamPackageChoice: TStreamPackageChoice;
begin
  result := spcSTR;
  if frmMODFLOW.cbSTR.Checked and frmMODFLOW.cbStreamTrib.Checked
    and frmMODFLOW.cbSFR.Checked and frmMODFLOW.cbSFRTrib.Checked then
  begin
    frmStreamLinkChoice := TfrmStreamLinkChoice.Create(nil);
    try
      frmStreamLinkChoice.ShowModal;
      result := TStreamPackageChoice(frmStreamLinkChoice.rgChoice.ItemIndex);
    finally
      frmStreamLinkChoice.Free;
    end;
  end
  else if frmMODFLOW.cbSTR.Checked and frmMODFLOW.cbStreamTrib.Checked then
  begin
    result := spcSTR;
  end
  else if frmMODFLOW.cbSFR.Checked and frmMODFLOW.cbSFRTrib.Checked then
  begin
    result := spcSFR;
  end
  else
  begin
    Assert(False);
  end;
end;

{$R *.DFM}

end.
