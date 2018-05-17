unit DeclutterUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ArgusDataEntry, AnePIE, Math;

type
  TDeclutterForm = class(TForm)
    Label1: TLabel;
    adeDesSpacing: TArgusDataEntry;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    adeDesAngle: TArgusDataEntry;
    cbSpacing: TCheckBox;
    cbAngle: TCheckBox;
    BitBtn3: TBitBtn;
    procedure cbSpacingClick(Sender: TObject);
    procedure cbAngleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function DeClutterContours(AString : String ; aneHandle : ANE_PTR) : string;
  end;

var
  DeclutterForm: TDeclutterForm;

procedure GDeclutterContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses ANECB, JoinUnit, UtilityFunctions, OptionsUnit;

type
  TVertex = Class(TObject)
    XCoord : double;
    YCoord : double;
  end;

Procedure ExtractCoordFromString(AString : string; var XCoord, YCoord : double);
var
  TabPosition : integer;
begin
  TabPosition := Pos(Chr(9),AString);
  XCoord := StrToFloat(Copy(AString,1,TabPosition-1));
  YCoord := StrToFloat(Copy(AString,TabPosition+1,Length(AString)));
end;

function TDeclutterForm.DeClutterContours(AString : String ; aneHandle : ANE_PTR) : string;
var
  ContourStringList : TStringList;
  ContourList : TList;
  Index,  HeadingIndex : integer;
  AContour: TContour;
  HeadingTest : boolean;
  ContourIndex, PointIndex : integer;
  DesiredSpacing, DesiredAngle : double;
  FirstPoint, SecondPoint, ThirdPoint, Dummy : TVertex ;
  X, Y : double;
  Segment1Length, Segment2Length : double;
  Angle : double;
begin
  ContourStringList := TStringList.Create;
  ContourList := TList.Create;
  ContourStringList.Text := AString;
  AContour := nil;
  HeadingTest := True;
  For Index := 0 to ContourStringList.Count -1 do
  begin
    if Pos('## Name:', ContourStringList.Strings[Index]) > 0 then
    begin
      AContour := TContour.Create;
      ContourList.Add(AContour);
      HeadingTest := True;
    end;
    if not (AContour = nil) then
    begin
      if HeadingTest
      then
        begin
          AContour.Heading.Add(ContourStringList.Strings[Index]);
        end
      else
        begin
          if not (ContourStringList.Strings[Index] = '') then
          begin
            AContour.Points.Add(ContourStringList.Strings[Index]);
          end;
        end;
      if Pos('# X pos', ContourStringList.Strings[Index]) > 0 then
      begin
        HeadingTest := False;
      end;
    end;
  end;
    For index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList.Items[index];
    for HeadingIndex := 0 to AContour.Heading.Count -1 do
    begin
      if Pos('# Points Count', AContour.Heading.Strings[HeadingIndex]) > 0 then
      begin
        AContour.Value := AContour.Heading.Strings[HeadingIndex + 1];
        AContour.Value := Copy(AContour.Value, Pos(Chr(9), AContour.Value)+ 1,
                          Length(AContour.Value));
        break;
      end;
    end;
  end;

  DesiredSpacing := StrToFloat(adeDesSpacing.Text);
  DesiredAngle := StrToFloat(adeDesAngle.Text)*Pi/180;

  FirstPoint := TVertex.Create;
  SecondPoint := TVertex.Create;
  ThirdPoint := TVertex.Create;


  try
    begin
      For ContourIndex := 0 to ContourList.Count -1 do
      begin
          AContour := ContourList.Items[ContourIndex];
          if AContour.Points.Count > 2 then
          begin
            ExtractCoordFromString(AContour.Points.Strings[AContour.Points.Count -1], X, Y ) ;
            FirstPoint.XCoord := X;
            FirstPoint.YCoord := Y;
            ExtractCoordFromString(AContour.Points.Strings[AContour.Points.Count -2], X, Y );
            SecondPoint.XCoord := X;
            SecondPoint.YCoord := Y;

            For PointIndex := AContour.Points.Count -3 downto 0 do
            begin
              ExtractCoordFromString(AContour.Points.Strings[PointIndex], X, Y );
              ThirdPoint.XCoord := X;
              ThirdPoint.YCoord := Y;
              Segment1Length := Sqrt(Sqr(ThirdPoint.XCoord - SecondPoint.XCoord)
                             + Sqr(ThirdPoint.YCoord - SecondPoint.YCoord));
              Segment2Length := Sqrt(Sqr(FirstPoint.XCoord - SecondPoint.XCoord)
                             + Sqr(FirstPoint.YCoord - SecondPoint.YCoord));

              Angle := 0;
              if cbAngle.Checked then
              begin
                Angle :=  Segment1Length * Segment2Length;
                if Angle <> 0 then
                begin
                  try
                    begin
                      Angle := (
                                  (ThirdPoint.XCoord - SecondPoint.XCoord)
                                 *(SecondPoint.XCoord - FirstPoint.XCoord)
                                  +
                                  (ThirdPoint.YCoord - SecondPoint.YCoord)
                                 *(SecondPoint.YCoord - FirstPoint.YCoord)
                                )/
                                (Segment1Length * Segment2Length);
                      If Angle > 1 then
                      begin
                        Angle := 0
                      end
                      else if Angle < 1 then
                      begin
                        Angle := Pi;
                      end
                      else
                      begin
                        Angle := Abs(ArcCos(Angle));
                      end
                    end;
                  except on Exception do
                    begin
                      ShowMessage(IntToStr(PointIndex) + ' ' + IntToStr(ContourIndex));
                    end;
                  end;
                end;
              end;
              If (cbSpacing.Checked and not cbAngle.Checked
                and (Segment1Length + Segment2Length < DesiredSpacing)) or
                 (not cbSpacing.Checked and cbAngle.Checked
                and (DesiredAngle < Angle)) or
                (cbSpacing.Checked and cbAngle.Checked
                and (DesiredAngle < Angle) and
                (Segment1Length + Segment2Length < DesiredSpacing))
              then
                begin
                  AContour.Points.Delete(PointIndex + 1);
                  Dummy := SecondPoint;
                  SecondPoint := ThirdPoint;
                  ThirdPoint := Dummy;
                end
              else
                begin
                  Dummy := FirstPoint;
                  FirstPoint := SecondPoint;
                  SecondPoint := ThirdPoint;
                  ThirdPoint := Dummy;
                end;
            end;
          end;
      end;
    end;
  finally
    begin
      FirstPoint.Free;
      SecondPoint.Free;
      ThirdPoint.Free;
    end;
  end;

  For index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList.Items[index];
    if (AContour.Points.Count = 3)
       and (AContour.Points.Strings[0] = AContour.Points.Strings[2]) then
    begin
      AContour.Points.Delete(2);
    end;
    for HeadingIndex := 0 to AContour.Heading.Count -1 do
    begin
      if Pos('# Points Count', AContour.Heading.Strings[HeadingIndex]) > 0 then
      begin
        AContour.Heading.Strings[HeadingIndex + 1] :=
           IntToStr(AContour.Points.Count) + Chr(9) + AContour.Value;
        break;
      end;
    end;
  end;

  ContourStringList.Text := '';
  For index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList.Items[index];
    AContour.Points.Add('');
    ContourStringList.Text := ContourStringList.Text + AContour.Heading.Text + AContour.Points.Text;
  end;


  result := '';
  For index := 0 to ContourStringList.Count -1 do
  begin
    result := result + ContourStringList.strings[index] + {Chr(13) +} Chr(10);
  end;

  result := result + {Chr(13) +} Chr(10);
  
  ContourStringList.Free;
  for index := ContourList.Count -1 downto 0 do
  begin
    AContour := ContourList.Items[index];
    AContour.Free;
  end;
  ContourList.Free;


end;

procedure GDeclutterContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  InfoText : ANE_STR;
  InfoTextString : String;
  ImportText : string;
  ABoolean : Boolean;
  Layer : TLayerOptions;
begin
  Screen.Cursor := crHourglass;
  try
    try
      ABoolean := True;
      ANE_LayerPropertySet(aneHandle, layerHandle,
         'Allow Intersection', kPIEBoolean, @ABoolean);
      ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @InfoText );
      InfoTextString := String(InfoText);

      DeclutterForm := TDeclutterForm.Create(Application);
      try
        if (DeclutterForm.ShowModal = mrOK) then
        begin
          ImportText := DeclutterForm.DeClutterContours(InfoTextString, aneHandle);
          ANE_LayerClear(aneHandle , layerHandle, False );
          Layer := TLayerOptions.Create(layerHandle);
          try
            Layer.AllowIntersection[aneHandle] := True;
          finally
            Layer.Free(aneHandle);
          end;

          ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, PChar(ImportText));
        end;
      finally
        begin
          DeclutterForm.Free;
        end;
      end;


     except
       on Exception do
          begin
            MessageDlg('Unknown Error', mtError, [mbOK], 0);
          end;
     end;
  finally
    begin
      Screen.Cursor := crDefault;
    end;
  end;
end;



procedure TDeclutterForm.cbSpacingClick(Sender: TObject);
begin
  adeDesSpacing.Enabled :=  cbSpacing.Checked;
end;

procedure TDeclutterForm.cbAngleClick(Sender: TObject);
begin
  adeDesAngle.Enabled := cbAngle.Checked;
end;

procedure TDeclutterForm.FormCreate(Sender: TObject);
var
  HelpDirectory : string;
begin
  if GetDllDirectory('JoinContoursPie.dll', HelpDirectory) then
  begin
    HelpFile := HelpDirectory + '\JoinContours.hlp'
  end;
end;

end.
