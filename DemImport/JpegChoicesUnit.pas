unit JpegChoicesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, jpeg;

type
  TfrmJpegChoices = class(TForm)
    seQuality: TSpinEdit;
    Label1: TLabel;
    cbProgressive: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SaveDialog1: TSaveDialog;
  private
    { Private declarations }
  public
    procedure SaveAsJPEG(BitMap: TBitMap);
    { Public declarations }
  end;

var
  frmJpegChoices: TfrmJpegChoices;

implementation

procedure TfrmJpegChoices.SaveAsJPEG(BitMap: TBitMap);
var
  JPEGImage : TJPEGImage;
begin
  SaveDialog1.FileName := '';
  if SaveDialog1.Execute  then
  begin
    JPEGImage := TJPEGImage.Create;
    try
      frmJpegChoices.seQuality.Value := JPEGImage.CompressionQuality;
      frmJpegChoices.cbProgressive.Checked := JPEGImage.ProgressiveEncoding;
      if frmJpegChoices.ShowModal = mrOK then
      begin
        JPEGImage.Assign(BitMap);

        JPEGImage.CompressionQuality := frmJpegChoices.seQuality.Value;
        JPEGImage.ProgressiveEncoding := frmJpegChoices.cbProgressive.Checked;
        JPEGImage.SaveToFile(SaveDialog1.FileName);
      end;

    finally
      JPEGImage.Free;
    end;

  end;
end;


{$R *.DFM}

end.
