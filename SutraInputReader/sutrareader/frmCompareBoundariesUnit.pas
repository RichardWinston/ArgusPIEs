unit frmCompareBoundariesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls;

type
  TfrmCompareBoundaries = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    Label1: TLabel;
    Label3: TLabel;
    edMaxPres: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    edMinPres: TEdit;
    edMaxConc: TEdit;
    edMinConc: TEdit;
    edMaxPresIndex: TEdit;
    Label2: TLabel;
    edMinPresIndex: TEdit;
    edMaxConcIndex: TEdit;
    edMinConcIndex: TEdit;
    edMaxPresSpecified: TEdit;
    edMinPresSpecified: TEdit;
    edMaxConcSpecified: TEdit;
    edMinConcSpecified: TEdit;
    Label5: TLabel;
    edMaxPresCalculated: TEdit;
    edMinPresCalculated: TEdit;
    edMaxConcCalculated: TEdit;
    edMinConcCalculated: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edMaxPresDigits: TEdit;
    edMinPresDigits: TEdit;
    edMaxConcDigits: TEdit;
    edMinConcDigits: TEdit;
    Label9: TLabel;
    btnAbout: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSpecPressure = record
    Index : integer;
    Pressure : double;
    Conc : double;
  end;

  TSpecConc = record
    Index : integer;
    Conc : double;
  end;


var
  frmCompareBoundaries: TfrmCompareBoundaries;

implementation

  {$R *.DFM}

uses Math, frmAboutUnit;

procedure GetCoordinates(var X, Y , Z : double; var I : longint);
  stdcall; external 'sutrareader.dll' name 'GETCOORDINATES';

//procedure GetNodeNumber(var NodeNum, IElem, INode : longint);
//  stdcall; external 'sutrareader.dll';

procedure INITIALIZE(var NumNodes, NumElem, NPresB, NConcB, IERRORCODE: longint;
  InputFile : string; FileNameLength : longint);
  stdcall; external 'sutrareader.dll';


//procedure GETSPECPRESNODENUMBER(var NodeIndex, NodeNumber: longint;
procedure GetSpecPresNodeNumber(var NodeIndex, NodeNumber: longint;
  var SpecPress, Conc: double);
  stdcall; external 'sutrareader.dll' name 'GETSPECPRESNODENUMBER';

procedure GetSpecConcNodeNumber(var NodeIndex, NodeNumber: longint;
//procedure GETSPECCONCNODENUMBER(var NodeIndex, NodeNumber: longint;
  var Conc: double)
  stdcall; external 'sutrareader.dll' name 'GETSPECCONCNODENUMBER';

procedure CLOSE_FILE;
  stdcall; external 'sutrareader.dll';

function FortranStrToFloat(AString : string) : double;
var
  DPos : integer;
  Sub : string;
begin
  AString := Trim(AString);
  DPos := Pos('d', AString);
  if DPos > 0 then
  begin
    AString[DPos] := 'e';
  end;
  DPos := Pos('D', AString);
  if DPos > 0 then
  begin
    AString[DPos] := 'E';
  end;
  if DecimalSeparator <> '.' then
  begin
    DPos := Pos('.', AString);
    if DPos > 0 then
    begin
      AString[DPos] := DecimalSeparator;
    end;
  end;
  Sub := Copy(AString, 2, Length(AString));
  DPos := Pos('+', Sub);
  if DPos > 0 then
  begin
    if (AString[DPos] <> 'e') and (AString[DPos] <> 'E') then
    begin
      AString := Copy(AString, 1, DPos) + 'E' + Copy(AString, DPos + 1, Length(AString))
    end;
  end;
  DPos := Pos('-', Sub);
  if DPos > 0 then
  begin
    if (AString[DPos] <> 'e') and (AString[DPos] <> 'E') then
    begin
      AString := Copy(AString, 1, DPos) + 'E' + Copy(AString, DPos + 1, Length(AString))
    end;
  end;
  result := StrToFloat(AString);
end;



procedure TfrmCompareBoundaries.Button1Click(Sender: TObject);
var
  FileName : string;
  NumNodes, NumElem, NPresB, NConcB, IERRORCODE, NodeNumber: longint;
  NodeIndex : integer;
  INode : longint;
  SpecPress, Conc : double;
  NodeFile : TextFile;
  Pressure, Concentration : array of Double;
  SpecPressureNodes :  array of TSpecPressure;
  SpecConcNodes : array of TSpecConc;
  AString : string;
  DataHasBeenRead : boolean;
  SpecPressure : TSpecPressure;
  SpecConc : TSpecConc;
  difference, AbsDif : double;
  MaxSpecPresDif : double;
  MinSpecPresDif : double;
  MaxSpecConcDif : double;
  MinSpecConcDif : double;
  MaxSpecPressureIndex : integer;
  MinSpecPressureIndex : integer;
  MaxSpecConcIndex : integer;
  MinSpecConcIndex : integer;

  MaxSpecPresDifCalculated : double;
  MinSpecPresDifCalculated : double;
  MaxSpecConcDifCalculated : double;
  MinSpecConcDifCalculated : double;

  MaxSpecPresDifSpecified : double;
  MinSpecPresDifSpecified : double;
  MaxSpecConcDifSpecified : double;
  MinSpecConcDifSpecified : double;

  Digits : integer;

  FirstTime1, FirstTime2 : boolean;
  Is2D: boolean;
  LineIndex: integer;
  TimeStep: integer;
  NumberString: string;
  procedure UpdateResults;
  var
    NodeIndex : integer;
    Average : double;
  begin
    if DataHasBeenRead then
    begin
      for NodeIndex := 0 to NPresB -1 do
      begin
        SpecPressure := SpecPressureNodes[NodeIndex];

        if SpecPressure.Index < 0 then
        begin
          Continue;
        end;

        difference := SpecPressure.Pressure - Pressure[SpecPressure.Index];
        Average := (SpecPressure.Pressure + Pressure[SpecPressure.Index])/2;
        if Average <> 0 then
        begin
          difference := difference/Average;
        end
        else if SpecPressure.Pressure <> 0 then
        begin
          difference := difference/SpecPressure.Pressure;
        end
        else if Pressure[SpecPressure.Index] <> 0 then
        begin
          difference := difference/Pressure[SpecPressure.Index];
        end;
        AbsDif := Abs(difference);
        if  (AbsDif > MaxSpecPresDif) or FirstTime1 then
        begin
          MaxSpecPresDif := AbsDif;
          MaxSpecPressureIndex := SpecPressure.Index;
          MaxSpecPresDifCalculated := Pressure[SpecPressure.Index];
          MaxSpecPresDifSpecified := SpecPressure.Pressure;
        end;
        if  (AbsDif < MinSpecPresDif) or FirstTime1 then
        begin
          MinSpecPresDif := AbsDif;
          MinSpecPressureIndex := SpecPressure.Index;
          MinSpecPresDifCalculated := Pressure[SpecPressure.Index];
          MinSpecPresDifSpecified := SpecPressure.Pressure;
        end;
        FirstTime1 := False;
      end;

      for NodeIndex := 0 to NConcB -1 do
      begin
        SpecConc := SpecConcNodes[NodeIndex];

        if SpecConc.Index < 0 then
        begin
          Continue;
        end;

        difference := SpecConc.Conc - Concentration[SpecConc.Index];
        Average := (SpecPressure.Conc + Concentration[SpecConc.Index])/2;

        if Average <> 0 then
        begin
          difference := difference/Average;
        end
        else if SpecConc.Conc <> 0 then
        begin
          difference := difference/SpecConc.Conc;
        end
        else if Concentration[SpecConc.Index] <> 0 then
        begin
          difference := difference/Concentration[SpecConc.Index];
        end;
        AbsDif := Abs(difference);

        if  (AbsDif > MaxSpecConcDif) or FirstTime2 then
        begin
          MaxSpecConcDif := AbsDif;
          MaxSpecConcIndex := SpecConc.Index;
          MaxSpecConcDifCalculated := Concentration[SpecConc.Index];
          MaxSpecConcDifSpecified := SpecConc.Conc;
        end;

        if  (AbsDif < MinSpecConcDif) or FirstTime2 then
        begin
          MinSpecConcDif := AbsDif;
          MinSpecConcIndex := SpecConc.Index;
          MinSpecConcDifCalculated := Concentration[SpecConc.Index];
          MinSpecConcDifSpecified := SpecConc.Conc;
        end;
        FirstTime2 := False;
      end;
    end;
  end;
begin
  TimeStep := 0;
  if OpenDialog1.Execute and OpenDialog2.Execute then
  begin
    Caption := 'CheckMatchBC ' + ExtractFileName(OpenDialog1.FileName)
      + ' ' + ExtractFileName(OpenDialog2.FileName);
    Screen.Cursor := crHourGlass;
    try
      SetCurrentDir(ExtractFileDir(OpenDialog1.FileName));
      FileName := ExtractFileName(OpenDialog1.FileName);
      INITIALIZE(NumNodes, NumElem, NPresB, NConcB, IERRORCODE,
        FileName, Length(FileName));
      try
        if IERRORCODE <> 0 then
        begin
          Beep;
          ShowMessage('Error ' + IntToStr(IERRORCODE));
          Exit;
        end
        else
        begin
          SetLength(SpecPressureNodes, NPresB);

          for NodeIndex := 0 to NPresB -1 do
          begin
            INode := NodeIndex;
            GetSpecPresNodeNumber(INode, NodeNumber, SpecPress, Conc);
            SpecPressureNodes[NodeIndex].Index := NodeNumber;
            SpecPressureNodes[NodeIndex].Pressure := SpecPress;
            SpecPressureNodes[NodeIndex].Conc := Conc;
          end;
          SetLength(SpecConcNodes, NConcB);
          for NodeIndex := 0 to NConcB -1 do
          begin
            INode := NodeIndex;
            GetSpecConcNodeNumber(INode, NodeNumber, Conc);
            SpecConcNodes[NodeIndex].Index := NodeNumber;
            SpecConcNodes[NodeIndex].Conc := Conc;
          end;

        end;

        FirstTime1 := True;
        FirstTime2 := True;
        SetLength(Pressure,NumNodes);
        SetLength(Concentration,NumNodes);
        NodeNumber := -1;
        DataHasBeenRead := False;
        AssignFile(NodeFile, OpenDialog2.FileName);
        try
          Reset(NodeFile);
          LineIndex := -1;
          Is2D := False;
          while not EOF(NodeFile) do
          begin
            Readln(NodeFile, AString);
            Inc(LineIndex);
            If (Length(AString) > 0) then
            begin
              if (AString[1] = '#')
                or (Pos('---',AString) > 0) 
                or (Pos('|',AString) > 0) then
              begin
                If (LineIndex = 3) and (Pos('2-D', AString) > 0) then
                begin
                  Is2D := True;
                end;
                If (Pos('TIME STEP', AString) > 0) then
                begin
                  AString := Copy(AString, 13, 9);
                  TimeStep := StrToInt(AString);
                  if TimeStep > 0 then
                  begin
                    UpdateResults;

                    NodeNumber := -1;
                    DataHasBeenRead := False;
                  end;
                end;
                if Pos('RUN TERMINATED', AString) > 0 then
                begin
                  break;
                end;


              end
              else
              begin
                if TimeStep > 0 then
                begin
                  Inc(NodeNumber);
                  if NodeNumber = NumNodes - 1 then
                  begin
                    DataHasBeenRead := True;
                  end;
                  Assert((NodeNumber < NumNodes) and (NodeNumber >= 0));
                  if Is2D then
                  begin
                    NumberString := Trim(Copy(AString,32,15));
                    Pressure[NodeNumber] := FortranStrToFloat(NumberString);
                    NumberString := Trim(Copy(AString,47,15));
                    Concentration[NodeNumber] := FortranStrToFloat(NumberString);
                  end
                  else
                  begin
                    NumberString := Trim(Copy(AString,47,15));
                    Pressure[NodeNumber] := FortranStrToFloat(NumberString);
                    NumberString := Trim(Copy(AString,62,15));
                    Concentration[NodeNumber] := FortranStrToFloat(NumberString);
                  end;
                end;
              end;
            end;
          end;
        finally
          CloseFile(NodeFile);
        end;
        UpdateResults;
        edMaxPres.Text := FloatToStr(MaxSpecPresDif);
        edMaxPresIndex.Text := IntToStr(MaxSpecPressureIndex+1);
        edMaxPresSpecified.Text := FloatToStr(MaxSpecPresDifSpecified);
        edMaxPresCalculated.Text := FloatToStr(MaxSpecPresDifCalculated);
        if MaxSpecPresDif > 0 then
        begin
          Digits := Trunc(-Log10(MaxSpecPresDif))+1;
          if Digits < 0 then Digits := 0;
          edMaxPresDigits.Text := IntToStr(Digits);
        end
        else
        begin
          edMaxPresDigits.Text := '';
        end;

        edMinPres.Text := FloatToStr(MinSpecPresDif);
        edMinPresIndex.Text := IntToStr(MinSpecPressureIndex+1);
        edMinPresSpecified.Text := FloatToStr(MinSpecPresDifSpecified);
        edMinPresCalculated.Text := FloatToStr(MinSpecPresDifCalculated);
        if MinSpecPresDif > 0 then
        begin
          Digits := Trunc(-Log10(MinSpecPresDif))+1;
          if Digits < 0 then Digits := 0;
          edMinPresDigits.Text := IntToStr(Digits);
        end
        else
        begin
          edMinPresDigits.Text := '';
        end;

        edMaxConc.Text := FloatToStr(MaxSpecConcDif);
        edMaxConcIndex.Text := IntToStr(MaxSpecConcIndex+1);
        edMaxConcSpecified.Text := FloatToStr(MaxSpecConcDifSpecified);
        edMaxConcCalculated.Text := FloatToStr(MaxSpecConcDifCalculated);
        if MaxSpecConcDif > 0 then
        begin
          Digits := Trunc(-Log10(MaxSpecConcDif))+1;
          if Digits < 0 then Digits := 0;
          edMaxConcDigits.Text := IntToStr(Digits);
        end
        else
        begin
          edMaxConcDigits.Text := '';
        end;

        edMinConc.Text := FloatToStr(MinSpecConcDif);
        edMinConcIndex.Text := IntToStr(MinSpecConcIndex+1);
        edMinConcSpecified.Text := FloatToStr(MinSpecConcDifSpecified);
        edMinConcCalculated.Text := FloatToStr(MinSpecConcDifCalculated);
        if MinSpecConcDif > 0 then
        begin
          Digits := Trunc(-Log10(MinSpecConcDif))+1;
          if Digits < 0 then Digits := 0;
          edMinConcDigits.Text := IntToStr(Digits);
        end
        else
        begin
          edMinConcDigits.Text := '';
        end;
      finally
        CLOSE_FILE;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmCompareBoundaries.btnAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal
end;

end.
