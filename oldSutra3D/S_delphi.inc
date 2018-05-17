{ Secrets of Delphi 3, by Ray Lischner. (1997, Waite Group Press).
  Copyright © 1996 The Waite Group, Inc.

  Define conditional macros, according to the version of Delphi.
  Delphi defines VER80=Delphi1, VER90=Delphi2, and VER100=Delphi3.
  Usually, features are upwardly compatible, so what is most interesting
  is knowing if the version is at Delphi 2 or later, Delphi 3 or later,
  and so on.

  This file defines Delphi1 for any version of Delphi, Delphi2 for
  version 2.0 or later, and Delphi3 for version 3.0 or later. To test
  for a specific version of Delphi, use the VER... labels. To test for
  a feature that depends on Windows 95 or Windows NT, use WIN32.
}

{$ifdef VER80}
  {$define Delphi1}
{$endif}
{$ifdef VER90}
  {$define Delphi1}
  {$define Delphi2}
{$endif}
{$ifdef VER100}
  {$define Delphi1}
  {$define Delphi2}
  {$define Delphi3}
{$endif}

