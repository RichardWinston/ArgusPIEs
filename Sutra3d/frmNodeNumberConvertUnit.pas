unit frmNodeNumberConvertUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, ArgusDataEntry, ComCtrls, ArgusFormUnit,
  AnePIE;

type
  TfrmNodeNumConvert = class(TArgusForm)
    PageControl1: TPageControl;
    tabArgusToSutra: TTabSheet;
    tabSutraToArgus: TTabSheet;
    sgSutraNodes: TStringGrid;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    adeSutraNodeNumber: TArgusDataEntry;
    adeArgusNodeNumberResult: TArgusDataEntry;
    rgConversionType: TRadioGroup;
    Panel2: TPanel;
    adeArgusNodeNumber: TArgusDataEntry;
    lblArgusNodeNumber: TLabel;
    lblSutraNodeNumber: TLabel;
    lblArgusNodeNumberResult: TLabel;
    adeUnitNumber: TArgusDataEntry;
    Label1: TLabel;
    adeLayerNumber: TArgusDataEntry;
    Label2: TLabel;
    procedure rgConversionTypeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure adeArgusNodeNumberChange(Sender: TObject);
    procedure adeSutraNodeNumberChange(Sender: TObject);
  private
    FNodeLayerCount: integer;
    procedure SetNodeLayerCount(const Value: integer);
  private
//    NodesPerLayer, ElementsPerLayer : integer;
    property NodeLayerCount : integer read FNodeLayerCount write SetNodeLayerCount;
    { Private declarations }
  public
    Procedure GetData;
    { Public declarations }
  end;

procedure GConvertNodeNumbers(aneHandle : ANE_PTR; const  fileName : ANE_STR;
  layerHandle : ANE_PTR) ; cdecl;

var
  frmNodeNumConvert: TfrmNodeNumConvert;

implementation

{$R *.DFM}

uses frmSutraUnit, SLSutraMesh, OptionsUnit, ANE_LayerUnit;

{ TfrmNodeNumConvert }

procedure TfrmNodeNumConvert.GetData;
begin
  NodeLayerCount := frmSutra.GetLayerCount;
end;

procedure TfrmNodeNumConvert.rgConversionTypeClick(Sender: TObject);
var
  NodeElementString : string;
  UnitIndex, LayerIndex, LayerNumber, LayerLimit : integer;
begin
  if not (csLoading in ComponentState) then
  begin
    if rgConversionType.ItemIndex = 0 then
    begin
      sgSutraNodes.RowCount := FNodeLayerCount + 1;
    end
    else
    begin
      sgSutraNodes.RowCount := FNodeLayerCount;
    end;
    NodeElementString := rgConversionType.Items[rgConversionType.ItemIndex];
    sgSutraNodes.Cells[2,0] := NodeElementString;
    tabArgusToSutra.Caption := 'Argus ' + NodeElementString + ' to SUTRA ' + NodeElementString;
    tabSutraToArgus.Caption := 'SUTRA ' + NodeElementString + ' to Argus ' + NodeElementString;
    SetLength(NodeElementString, Length(NodeElementString) -1);
    Caption := 'Convert ' + NodeElementString + ' Numbers';
    lblArgusNodeNumber.Caption := NodeElementString + ' Number';
    lblSutraNodeNumber.Caption := 'SUTRA ' + NodeElementString + ' Number';
    lblArgusNodeNumberResult.Caption := 'Argus ' + NodeElementString + ' Number';
      LayerNumber := 0;
    for UnitIndex := 1 to frmSutra.sgGeology.RowCount -1 do
    begin
      LayerLimit := frmSutra.GetCountOfAUnit(UnitIndex);
      if (UnitIndex = 1) and (rgConversionType.ItemIndex = 0) then
      begin
        Inc(LayerLimit);
      end;
      for LayerIndex := 1 to LayerLimit do
      begin
        Inc(LayerNumber);
        sgSutraNodes.Cells[0,LayerNumber] := IntToStr(UnitIndex);
        sgSutraNodes.Cells[1,LayerNumber] := IntToStr(LayerNumber);
      end;
    end;
  end;
  adeSutraNodeNumberChange(nil);
  adeArgusNodeNumberChange(nil);
end;

procedure TfrmNodeNumConvert.SetNodeLayerCount(const Value: integer);
begin
  FNodeLayerCount := Value;
  rgConversionTypeClick(nil);
end;

procedure TfrmNodeNumConvert.FormCreate(Sender: TObject);
begin
  inherited;
  sgSutraNodes.Cells[0,0] := 'Unit #';
  sgSutraNodes.Cells[1,0] := 'Layer #';
  Constraints.MinHeight := Height;
end;

procedure TfrmNodeNumConvert.adeArgusNodeNumberChange(Sender: TObject);
var
  NodeElementNumber : integer;
//  ItemsPerLayer : integer;
  NumberOfLayers : integer;
  NextNodeElementNumber : integer;
  LayerIndex : integer;
begin
  if (adeArgusNodeNumber.Text <> '') and not (csLoading	in ComponentState)  then
  begin
    NodeElementNumber := StrToInt(adeArgusNodeNumber.Text);
    if rgConversionType.ItemIndex = 0 then
    begin
      // Nodes
//      ItemsPerLayer := NodesPerLayer;
      NumberOfLayers := NodeLayerCount;
    end
    else
    begin
      // Elements
//      ItemsPerLayer := ElementsPerLayer;
      NumberOfLayers := NodeLayerCount -1;
    end;
    NextNodeElementNumber := (NodeElementNumber -1)*NumberOfLayers + 1;
    for LayerIndex := 1 to NumberOfLayers do
    begin
      sgSutraNodes.Cells[2,LayerIndex] := IntToStr(NextNodeElementNumber);
      Inc(NextNodeElementNumber);
    end;
  end;
end;

procedure TfrmNodeNumConvert.adeSutraNodeNumberChange(Sender: TObject);
var
  NodeElementNumber, LayerNumber, NewNodeElementNumber, UnitIndex : integer;
  NumberOfLayers, LayerLimit : integer;
begin
  if (adeSutraNodeNumber.Text <> '')and not (csLoading	in ComponentState) then
  begin
    NodeElementNumber := StrToInt(adeSutraNodeNumber.Text);
    if rgConversionType.ItemIndex = 0 then
    begin
      // Nodes
//      ItemsPerLayer := NodesPerLayer;
      NumberOfLayers := NodeLayerCount;
    end
    else
    begin
      // Elements
//      ItemsPerLayer := ElementsPerLayer;
      NumberOfLayers := NodeLayerCount -1;
    end;
    LayerNumber := (NodeElementNumber -1) mod NumberOfLayers + 1;
    NewNodeElementNumber := (NodeElementNumber -1) div NumberOfLayers + 1;
    adeLayerNumber.Text := IntToStr(LayerNumber);
    adeArgusNodeNumberResult.Text := IntToStr(NewNodeElementNumber);
    for UnitIndex := 1 to frmSutra.sgGeology.RowCount -1 do
    begin
      LayerLimit := frmSutra.GetCountOfAUnit(UnitIndex);
      if (UnitIndex = 1) and (rgConversionType.ItemIndex = 0) then
      begin
        Inc(LayerLimit);
      end;
      if LayerLimit >= LayerNumber then
      begin
        adeUnitNumber.Text := IntToStr(UnitIndex);
        break;
      end
      else
      begin
        Dec(LayerNumber,LayerLimit);
      end;
    end;
  end;
end;

procedure GConvertNodeNumbers(aneHandle : ANE_PTR; const  fileName : ANE_STR;
  layerHandle : ANE_PTR) ; cdecl;
begin
  // Check that another model doesn't have a dialog box open. If it does,
  // prevent this one from openning because that would corrupt the data
  // for the other model.
  if EditWindowOpen
  then
  begin
    // Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    // make sure the project options used in exporting data are set correctly.
    try  // try 1
      begin
        Try
          begin
            frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
              as TfrmSutra;
            frmNodeNumConvert := TfrmNodeNumConvert.Create(application);
            try
              frmNodeNumConvert.CurrentModelHandle := aneHandle;
              frmNodeNumConvert.GetData;
              frmNodeNumConvert.ShowModal;
            finally
                frmNodeNumConvert.Free
            end;
          end
        except on E: Exception do
          begin
            Beep;
            MessageDlg(E.Message, mtError, [mbOK], 0);
          end;
        end;
      end;
    finally
        EditWindowOpen := False;
    end; // try 1
  end; // if EditWindowOpen else
//  returnTemplate^ := Template;
end;


end.
