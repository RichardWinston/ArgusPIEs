
// The data for most of these color schemes comes from
// http://geography.uoregon.edu/datagraphics/color_scales.htm
 
unit ColorSchemes;

interface

uses Graphics;

type
  TColorComponents = (ccRed, ccGreen, ccBlue);
  TColorArray = array[TColorComponents] of double;

function FracLookup(Fraction: real; const LookUpTable : array of TColorArray): TColor;
function FracToBlueDarkOrange(Fraction: real): TColor;
function FracToBlueGray(Fraction: real): TColor;
function FracToBlueGreen(Fraction: real): TColor;
function FracToBlueOrange(Fraction: real): TColor;
function FracToBlueRed(Fraction: real): TColor;
function FracToBrownBlue(Fraction: real): TColor;
function FracToGreenMagenta(Fraction: real): TColor;
function FracToSpectrum(Fraction: real): TColor;
function FracToBlue_OrangeRed(Fraction: real): TColor;
function FracToLightBlue_DarkBlue(Fraction: real): TColor;

implementation

function FracToSpectrum(Fraction: real): TColor;
var
  Choice: integer;
begin
  Assert((Fraction >= 0) and (Fraction <= 1));
  fraction := Fraction * 4;
  Choice := Trunc(fraction);
  fraction := Frac(fraction);
  case Choice of
    0:
      begin
        result := Round(Fraction * $FF) * $100 + $FF; // R -> R+G
      end;
    1:
      begin
        result := $FF00 + Round((1 - Fraction) * $FF); // R+G -> G
      end;
    2:
      begin
        result := Round(Fraction * $FF) * $10000 + $FF00; // G -> G+B
      end;
    3:
      begin
        result := $FF0000 + Round((1 - Fraction) * $FF) * $100; // G+B -> B
      end;
    4:
      begin
        result := $FF0000;// + Round(Fraction * $FF); // B -> B+R
      end;
{    5:
      begin
        result := $FF00FF; // B+R
      end;       }
  else
    begin
      result := 0;
      Assert(False);
    end;
  end;
end;

function FracToGreenMagenta(Fraction: real): TColor;
var
  Choice: integer;
begin
  Assert((Fraction >= 0) and (Fraction <= 1));
  fraction := Fraction * 3 + 0.5;
  Choice := Trunc(fraction);
  fraction := Frac(fraction);
  case Choice of
    0:
      begin
        result := Round(Fraction * $FF) * $100;
      end;
    1:
      begin
        result := $FF00 + Round(Fraction * $FF) + Round(Fraction * $FF) * $10000;
      end;
    2:
      begin
        result := $FF + $FF0000 + Round((1-Fraction) * $FF) * $100;
      end;
    3:
      begin
        result := Round((1-Fraction) * $FF) * $10000 + Round((1-Fraction) * $FF);
      end;
  else
    begin
      result := 0;
      Assert(False);
    end;
  end;
end;

function FracLookup(Fraction: real; const LookUpTable : array of TColorArray): TColor;
var
  Choice: integer;
  RedFraction: double;
  GreenFraction: double;
  BlueFraction: double;
  LookUpLength: integer;
begin
  Assert((Fraction >= 0) and (Fraction <= 1));
  LookUpLength := length(LookUpTable)-1;
  fraction := Fraction * LookUpLength;
  Choice := Trunc(fraction);
  fraction := Frac(fraction);
  if Choice = LookUpLength then
  begin
    RedFraction := LookUpTable[LookUpLength,ccRed];
    GreenFraction := LookUpTable[LookUpLength,ccGreen];
    BlueFraction := LookUpTable[LookUpLength,ccBlue];
  end
  else
  begin
    RedFraction := (1-fraction)*LookUpTable[Choice,ccRed]
      + fraction*LookUpTable[Choice+1,ccRed];
    GreenFraction := (1-fraction)*LookUpTable[Choice,ccGreen]
      + fraction*LookUpTable[Choice+1,ccGreen];
    BlueFraction := (1-fraction)*LookUpTable[Choice,ccBlue]
      + fraction*LookUpTable[Choice+1,ccBlue];
  end;

  result := Round(RedFraction * $FF)
    + Round(GreenFraction * $FF) * $100
    + Round(BlueFraction * $FF) * $10000;
end;

function FracToBlueRed(Fraction: real): TColor;
const
  LookUpTable : array[0..17] of TColorArray =
  (
  (0.142, 0, 0.85),
  (0.097, 0.112, 0.97),
  (0.16, 0.342, 1),
  (0.24, 0.531, 1),
  (0.34, 0.692, 1),
  (0.46, 0.829, 1),
  (0.6, 0.92, 1),
  (0.74, 0.978, 1),
  (0.92, 1, 1),
  (1, 1, 0.92),
  (1, 0.948, 0.74),
  (1, 0.84, 0.6),
  (1, 0.676, 0.46),
  (1, 0.472, 0.34),
  (1, 0.24, 0.24),
  (0.97, 0.155, 0.21),
  (0.85, 0.085, 0.187),
  (0.65, 0, 0.13)
  );
begin
  result := FracLookup(Fraction, LookUpTable);
end;

function FracToBlueDarkOrange(Fraction: real): TColor;
const
  LookUpTable : array[0..17] of TColorArray =
  (
  (0, 0.4, 0.4),
  (0, 0.6, 0.6),
  (0, 0.8, 0.8),
  (0, 1, 1),
  (0.2, 1, 1),
  (0.4, 1, 1),
  (0.6, 1, 1),
  (0.7, 1, 1),
  (0.8, 1, 1),
  (0.9, 1, 1),
  (1, 0.9, 0.8),
  (1, 0.793, 0.6),
  (1, 0.68, 0.4),
  (1, 0.56, 0.2),
  (1, 0.433, 0),
  (0.8, 0.333, 0),
  (0.6, 0.24, 0),
  (0.4, 0.153, 0)
  );
begin
  result := FracLookup(Fraction, LookUpTable);
end;

function FracToBlueGreen(Fraction: real): TColor;
const
  LookUpTable : array[0..13] of TColorArray =
  (
  (0, 0, 1),
  (0.2, 0.2, 1),
  (0.4, 0.4, 1),
  (0.6, 0.6, 1),
  (0.7, 0.7, 1),
  (0.8, 0.8, 1),
  (0.9, 0.9, 1),
  (0.9, 1, 0.9),
  (0.8, 1, 0.8),
  (0.7, 1, 0.7),
  (0.6, 1, 0.6),
  (0.4, 1, 0.4),
  (0.2, 1, 0.2),
  (0, 1, 0)
  );
begin
  result := FracLookup(Fraction, LookUpTable);
end;

function FracToBrownBlue(Fraction: real): TColor;
const
  LookUpTable : array[0..11] of TColorArray =
  (
  (0.2, 0.1, 0),
  (0.4, 0.187, 0),
  (0.6, 0.379, 0.21),
  (0.8, 0.608, 0.48),
  (0.85, 0.688, 0.595),
  (0.95, 0.855, 0.808),
  (0.8, 0.993, 1),
  (0.6, 0.973, 1),
  (0.4, 0.94, 1),
  (0.2, 0.893, 1),
  (0, 0.667, 0.8),
  (0, 0.48, 0.6)
  );
begin
  result := FracLookup(Fraction, LookUpTable);
end;

function FracToBlueGray(Fraction: real): TColor;
const
  LookUpTable : array[0..7] of TColorArray =
  (
  (0, 0.6, 0.8),
  (0.4, 0.9, 1),
  (0.6, 1, 1),
  (0.8, 1, 1),
  (0.9, 0.9, 0.9),
  (0.6, 0.6, 0.6),
  (0.4, 0.4, 0.4),
  (0.2, 0.2, 0.2)
  );
begin
  result := FracLookup(Fraction, LookUpTable);
end;

function FracToBlueOrange(Fraction: real): TColor;
const
  LookUpTable : array[0..11] of TColorArray =
  (
  (0, 0.167, 1),
  (0.1, 0.4, 1),
  (0.2, 0.6, 1),
  (0.4, 0.8, 1),
  (0.6, 0.933, 1),
  (0.8, 1, 1),
  (1, 1, 0.8),
  (1, 0.933, 0.6),
  (1, 0.8, 0.4),
  (1, 0.6, 0.2),
  (1, 0.4, 0.1),
  (1, 0.167, 0)
  );
begin
  result := FracLookup(Fraction, LookUpTable);
end;

function FracToBlue_OrangeRed(Fraction: real): TColor;
const
  LookUpTable : array[0..13] of TColorArray =
  (
  (0.03, 0.353, 1),
  (0.2, 0.467, 1),
  (0.35, 0.567, 1),
  (0.55, 0.7, 1),
  (0.75, 0.833, 1),
  (0.9, 0.933, 1),
  (0.97, 0.98, 1),
  (1, 1, 0.8),
  (1, 1, 0.6),
  (1, 1, 0),
  (1, 0.8, 0),
  (1, 0.6, 0),
  (1, 0.4, 0),
  (1, 0, 0)
  );
begin
  result := FracLookup(Fraction, LookUpTable);
end;

function FracToLightBlue_DarkBlue(Fraction: real): TColor;
const
  LookUpTable : array[0..9] of TColorArray =
  (
  (0.9, 1, 1),
  (0.8, 0.983, 1),
  (0.7, 0.95, 1),
  (0.6, 0.9, 1),
  (0.5, 0.833, 1),
  (0.4, 0.75, 1),
  (0.3, 0.65, 1),
  (0.2, 0.533, 1),
  (0.1, 0.4, 1),
  (0, 0.25, 1)
  );
begin
  result := FracLookup(Fraction, LookUpTable);
end;


end.
