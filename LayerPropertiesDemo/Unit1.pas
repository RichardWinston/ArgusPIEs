unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AnePIE, OptionsUnit, StdCtrls, ExtCtrls, ArgusDataEntry;

type
  TForm1 = class(TForm)
    btnGet: TButton;
    btnSet: TButton;
    adeTo: TArgusDataEntry;
    adeFrom: TArgusDataEntry;
    Label1: TLabel;
    Label2: TLabel;
    edLayer: TEdit;
    Label3: TLabel;
    rgProp: TRadioGroup;
    cbTo: TCheckBox;
    cbFrom: TCheckBox;
    edParam: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure btnGetClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    AHandle : ANE_PTR;
//    ProjectOptions : TProjectOptions;

    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ANECB;

procedure TForm1.btnGetClick(Sender: TObject);
var
  LayerHandle : ANE_PTR;
//  ParameterIndex : ANE_INT32;
  LayerName : String;
  LayerOptions : TLayerOptions;
  ProjectOptions : TProjectOptions;
  An_ANE_STR : ANE_STR;
begin
  LayerName := edLayer.Text;
  GetMem(An_ANE_STR, Length(LayerName) + 1);
  try
    StrPCopy(An_ANE_STR,LayerName);
    LayerHandle := ANE_LayerGetHandleByName(AHandle, An_ANE_STR);
  finally
    FreeMem(An_ANE_STR);
  end;

  if LayerHandle <> nil then
  begin
    LayerOptions := TLayerOptions.Create(AHandle, LayerHandle);
    ProjectOptions := TProjectOptions.Create(AHandle);
    try
      case rgProp.ItemIndex of
        0: cbFrom.Checked := LayerOptions.AllowIntersection;
        1: cbFrom.Checked := LayerOptions.CoordXRight;
        2: cbFrom.Checked := LayerOptions.CoordYUp ;
        3: cbFrom.Checked := LayerOptions.GridReverseXDirection ;
        4: cbFrom.Checked := LayerOptions.GridReverseYDirection  ;
        5: adeFrom.Text   := LayerOptions.CoordUnits;
        6: adeFrom.Text   := FloatToStr(LayerOptions.CoordScale);
        7: adeFrom.Text   := FloatToStr(LayerOptions.CoordXYRatio);
        8: adeFrom.Text   := IntToStr(LayerOptions.NumObjects(pieContourObject));
        9: if LayerOptions.LayerType = pieInformationLayer then
          Label5.Caption := 'Information' else Label5.Caption := 'not Information';
        10: ProjectOptions.LayerNames([pieInformationLayer], Memo1.Lines);
        11: LayerOptions.Remove(True);
        12: LayerOptions.ClearLayer(False);
        13: LayerOptions.Rename(Label5.Caption);
        14: adeFrom.Text   := IntToStr(LayerOptions.NumParameters(pieLayerSubParam));
        15: Edit1.Text := ProjectOptions.CurrentDirectory;
        16: ProjectOptions.CurrentLayer := LayerHandle;
        17: adeFrom.Text   := ProjectOptions.ExportSeparator;
        18: adeFrom.Text   := IntToStr(ProjectOptions.ExportWrap);
        19: adeFrom.Text   := ProjectOptions.ExportDelimiter;
        20: adeFrom.Text   := ProjectOptions.CopyDelimiter;
      else
        begin
        end;
      end;
      adeTo.Text := adeFrom.Text;
      cbTo.Checked := cbFrom.Checked;
    finally
      LayerOptions.Free;
      ProjectOptions.Free;
    end;

  end;

{    case rgBool.ItemIndex of
      0: adeFrom.Text := IntToStr(Ord(ProjectOptions.ExportDelimiter));
      1: adeFrom.Text := IntToStr(Ord(ProjectOptions.ExportSeparator));
      2: adeFrom.Text := IntToStr(Ord(ProjectOptions.ElemLinePrefix));
      3: adeFrom.Text := IntToStr(Ord(ProjectOptions.NodeLinePrefix));
      4: adeFrom.Text := IntToStr(Ord(ProjectOptions.CopyDelimiter));
    else
      begin
      end;
    end;
    adeTo.Text := adeFrom.Text; }

end;

procedure TForm1.btnSetClick(Sender: TObject);
var
  LayerHandle : ANE_PTR;
  LayerName, parameterName : String;
//  ParamOptions : TParameterOptions;
  ParameterIndex : integer;
  ProjectOptions : TProjectOptions;
  LayerOptions : TLayerOptions;
  An_ANE_STR : ANE_STR;
begin
  LayerName := edLayer.Text;
  GetMem(An_ANE_STR, Length(LayerName) + 1);
  try
    StrPCopy(An_ANE_STR,LayerName);
    LayerHandle := ANE_LayerGetHandleByName(AHandle, An_ANE_STR);
  finally
    FreeMem(An_ANE_STR);
  end;

  if LayerHandle <> nil then
  begin
    parameterName := edParam.Text;
    ParameterIndex := UGetParameterIndex(AHandle,
         LayerHandle,  parameterName);
    if ParameterIndex > -1 then
    begin
//      ParamOptions := TParameterOptions.Create(AHandle,
//         LayerHandle, ParameterIndex);
      ProjectOptions := TProjectOptions.Create(AHandle);
//      ProjectOptions.CurrentDirectory := Edit1.Text;
      case rgProp.ItemIndex of
        17: ProjectOptions.ExportSeparator := adeTo.Text[1];
        18: ProjectOptions.ExportWrap := StrToInt(adeTo.Text);
        19: ProjectOptions.ExportDelimiter := adeTo.Text[1];
        20: ProjectOptions.CopyDelimiter := adeTo.Text[1];
      end;
      ProjectOptions.Free;
//      ParamOptions.Units := adeTo.Text;
//      ParamOptions.Free;
    end;

    LayerOptions := TLayerOptions.Create(AHandle, LayerHandle);
    try
      case rgProp.ItemIndex of
        0: LayerOptions.AllowIntersection :=   cbFrom.Checked ;
        3: LayerOptions.GridReverseXDirection :=  cbFrom.Checked ;
        4: LayerOptions.GridReverseYDirection :=  cbFrom.Checked ;
      else
        begin
          ShowMessage('Can''t set that');
        end;
      end;

      case rgProp.ItemIndex of
        0: cbFrom.Checked := LayerOptions.AllowIntersection;
        1: cbFrom.Checked := LayerOptions.CoordXRight;
        2: cbFrom.Checked := LayerOptions.CoordYUp ;
        3: cbFrom.Checked := LayerOptions.GridReverseXDirection ;
        4: cbFrom.Checked := LayerOptions.GridReverseYDirection  ;
        5: adeFrom.Text   := LayerOptions.CoordUnits;
        6: adeFrom.Text   := FloatToStr(LayerOptions.CoordScale);
        7: adeFrom.Text   := FloatToStr(LayerOptions.CoordXYRatio);
      else
        begin
        end;
      end;
    finally
      LayerOptions.Free;
    end;

  end;
{    case rgBool.ItemIndex of
      0:  ProjectOptions.ExportDelimiter := Char(StrToInt(adeTo.Text));
      1:  ProjectOptions.ExportSeparator := Char(StrToInt(adeTo.Text));
      2:  ProjectOptions.ElemLinePrefix := Char(StrToInt(adeTo.Text));
      3:  ProjectOptions.NodeLinePrefix := Char(StrToInt(adeTo.Text));
      4:  ProjectOptions.CopyDelimiter := Char(StrToInt(adeTo.Text));
    else
      begin
      end;
    end;

    case rgBool.ItemIndex of
      0: adeFrom.Text := IntToStr(Ord(ProjectOptions.ExportDelimiter));
      1: adeFrom.Text := IntToStr(Ord(ProjectOptions.ExportSeparator));
      2: adeFrom.Text := IntToStr(Ord(ProjectOptions.ElemLinePrefix));
      3: adeFrom.Text := IntToStr(Ord(ProjectOptions.NodeLinePrefix));
      4: adeFrom.Text := IntToStr(Ord(ProjectOptions.CopyDelimiter));
    else
      begin
      end;
    end;  }


end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  ProjectOptions.Free;
end;

end.
