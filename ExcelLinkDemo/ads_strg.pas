{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
"http://www.w3.org/TR/REC-html40/loose.dtd">
<HTML><BODY BGCOLOR="#ffffff"><PRE>  }

Unit Ads_Strg;

{Copyright(c)1998 Advanced Delphi Systems

 Richard Maley
 Advanced Delphi Systems
 12613 Maidens Bower Drive
 Potomac, MD 20854 USA
 phone 301-840-1554
 maley@advdelphisys.com
 maley@compuserve.com
 maley@cpcug.org}

Interface

Uses
  SysUtils, Classes, ExtCtrls, StdCtrls;

Const RunOutsideIDE_ads        = True;
Const RunOutsideIDEDate_ads    = '12/1/98';
Const RunOutsideIDECompany_ads = 'Advanced Delphi Systems';
Const RunOutsideIDEPhone_ads   = 'Please purchase at (301) 840-1554';


{!~ Deletes all occurances of a Character in a String}
Function DeleteCharacterInString(InputCharacter,InputString: String): String;

{!~ Deletes all LineFeed Carriage Returns}
function DeleteLineBreaks(const S: string): string;

{!~ Deletes all occurances of specified substring in a String}
Function DeleteSubStringInString(substring,InputString: String): String;

{!~ Deletes all occurances of specified substring in a String and is case
insensitive.}
Function DeleteSubStringInStringNoCase(substring,InputString: String): String;

{!~ Throws away all keys except a-z and A-Z}
Procedure KeyPressOnlyAToZ(Var Key: Char);

{!~ Throws away all keys except 0-9,-,+,.}
Procedure KeyPressOnlyNumbers(Var Key: Char);

{!~ Throws away all keys except 0-9}
Procedure KeyPressOnlyNumbersAbsolute(Var Key: Char);

{!~ Returns The Length Of The String}
Function Len(InputString: String): Integer;

{!~ Returns a string converted to lower case}
Function Lower(InputString: String): String;

{!~ Throws away all characters except 0-9,-,+,.}
Function NumbersOnly(InputString: String): String;

{!~ Throws away all characters except 0-9}
Function NumbersOnlyAbsolute(InputString: String): String;

{!~ Returns the Proper form of a string, i.e., each word
starts with a capitalized letter and all subsequent
letters are lowercase}
Function Proper(S : String): String;

{!~ Replaces all occurances of a character in a string
with a new character}
Function ReplaceCharInString(S,OldChar,NewChar :String): String;

{!~ Replaces all occurances of a Character in a String}
Function ReplaceCharacterInString(
           OldChar,
           NewChar,
           InputString: String): String;

{!~
Replaces all occurances of specified substring in a String.  This will have problems if
the OldSubString is Contained in the NewSubstring.  This is case sensitive.
}
Function ReplaceSubStringInString(OldSubString,NewSubString,InputString: String): String;

{!~
Replaces all occurances of specified substring in a String.  This will have problems if
the OldSubString is Contained in the NewSubstring.  This is case insensitive.
}
Function ReplaceSubStringInStringNoCase(OldSubString,NewSubString,InputString: String): String;

{!~ Pads or truncates a String and Justifies Left if StrJustify=True}
Function StringPad(
  InputStr,
  FillChar: String;
  StrLen: Integer;
  StrJustify: Boolean): String;

{!~
All matches are added to the Stringlist.
}
Function String_GrepAllToStringList(
  Source                  : String;   //The input string
  StartTag                : String;   //The start tag
  EndTag                  : String;   //The end tag
  Containing              : String;   //A match must contain this string
  Var StringList          : TStringList;   //A List of Matches
  CaseSensitiveTags       : Boolean;  //True if tags are casesensitive
  CaseSensitiveContaining : Boolean   //True if Containing string is casesensitive
  ): Boolean;                         //True if a match was found

{!~
Returns the contents of a string between two tags.  The tag
information is not returned.  Finding the tags is case sensitive.
}
Function String_Grep_Contents(Source, StartTag, EndTag: String): String;

{!~
STRING_GREP_DETAIL

This is a full featured grep function.  All data associated
with the grep operation is returned.  The substring before the
match section is stored in the BeforeString variable.  The Match
Substring is stored in two variables.  The variable MatchwithTags
stores the match substring wrapped in the Start and End Tags.
The variable MatchWithoutTags stores the match substring without
the Start and End Tags. CaseSensitivity can be toggled for both
the tags and the Containing String using the booleans
CaseSensitiveTags and CaseSensitiveContaining. For a match to be
successful it must satisfy all criteria.  If the Containing String
is null this criteria is not applied.
}
Function String_Grep_Detail(
  Source                  : String;   //The input string
  StartTag                : String;   //The start tag
  EndTag                  : String;   //The end tag
  Containing              : String;   //A match must contain this string
  Var BeforeString        : String;   //The substring prior to the match
  Var MatchWithTags       : String;   //The match string including tags
  Var MatchWithoutTags    : String;   //the match string without the tags
  Var AfterString         : String;   //The substring after the match with tags
  CaseSensitiveTags       : Boolean;  //True if tags are casesensitive
  CaseSensitiveContaining : Boolean   //True if Containing string is casesensitive
  ): Boolean;                         //True if a match was found

{!~
STRING_LINEFEED_FORMAT

The String_LineFeed_Format function adjusts all line breaks in the given
string "SourceString" to be true CR/LF sequences. The function changes any
CR characters not followed by a LF and any LF characters not preceded by a
CR into CR/LF pairs. It also converts LF/CR pairs to CR/LF pairs. The LF/CR
pair is common in Unix text files.
}
Function String_LineFeed_Format(SourceString : String): String;

{!~
Inserts a Carriage Return/Line Feed at the index position.
}
Function String_LineFeed_Insert(SourceString : String; Index : Integer): String;

{!~
STRING_REPLACE

Replace all occurances of OldSubString with NewSubString in SourceString
}
Function String_Replace(
  OldSubString : String;
  NewSubString : String;
  SourceString : String): String;

{!~
STRING_REPLACE_NOCASE

Replace all occurances of OldSubString with NewSubString in
SourceString ignoring case
}
Function String_Replace_NoCase(
  OldSubString : String;
  NewSubString : String;
  SourceString : String): String;

{!~
STRING_REVERSE

Returns a string whose values are all reversed,i.e. , the
first character is last and the last is first.
}
Function String_Reverse(S : String): String;

{!~ Returns a SubString of a String.
Can only handle strings up to 255 characters.}
Function SubStr(InputString: String; StartPos, StringLength: Byte): String;

{!~ Trims blank spaces from both sides of the string}
Function TrimBlanksFromEnds(InputString: String): String;

{!~ Trims blank spaces from the left of the string}
Function TrimBlanksLeft(InputString: String): String;

{!~ Trims blank spaces from the right of the string}
Function TrimBlanksRight(InputString: String): String;

{!~ Converts String To UpperCase}
Function Upper(InputString: String): String;

Implementation

Type
  TPanel_Cmp_Sec_ads = class(TPanel)
  Public
    procedure ResizeShadowLabel(Sender: TObject);
  End;

procedure TPanel_Cmp_Sec_ads.ResizeShadowLabel(
  Sender     : TObject);
Var
  PH, PW : Integer;
  LH, LW : Integer;
begin
  PH := TPanel(Sender).Height;
  PW := TPanel(Sender).Width;
  LH := TLabel(Controls[0]).Height;
  LW := TLabel(Controls[0]).Width;
  TLabel(Controls[0]).Top  := ((PH-LH) div 2)-3;
  TLabel(Controls[0]).Left := ((Pw-Lw) div 2)-3;
end;

Type
  TEditKeyFilter = Class(TEdit)
  Published
    {!~ Throws away all keys except 0-9,-,+,.}
    Procedure OnlyNumbers(Sender: TObject; var Key: Char);

    {!~ Throws away all keys except 0-9}
    Procedure OnlyNumbersAbsolute(Sender: TObject; var Key: Char);

    {!~ Throws away all keys except a-z and A-Z}
    Procedure OnlyAToZ(Sender: TObject; var Key: Char);

  End;

{!~ Throws away all keys except 0-9,-,+,.}
Procedure TEditKeyFilter.OnlyNumbers(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyNumbers(Key);
End;

{!~ Throws away all keys except 0-9}
Procedure TEditKeyFilter.OnlyNumbersAbsolute(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyNumbersAbsolute(Key);
End;

{!~ Throws away all keys except a-z and A-Z}
Procedure TEditKeyFilter.OnlyAToZ(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyAToZ(Key);
End;
{!~ Deletes all occurances of a Character in a String}
Function DeleteCharacterInString(InputCharacter,InputString: String): String;
Var
  CharPos : Integer;
Begin
  Result := InputString;
  While True Do
  Begin
    CharPos := Pos(InputCharacter,InputString);
    If Not (CharPos = 0) Then
    Begin
      Delete(InputString,CharPos,1);
    End
    Else
    Begin
      Break;
    End;
  End;
  Result := InputString;
End;

{!~ Deletes all LineFeed Carriage Returns}
function DeleteLineBreaks(const S: string): string;
var
  Source, SourceEnd: PChar;
begin
  Source := Pointer(S);
  SourceEnd := Source + Length(S);
  while Source < SourceEnd do
  begin
    case Source^ of
      #10: Source^ := #32;
      #13: Source^ := #32;
    end;
    Inc(Source);
  end;
  Result := S;
end;

{!~ Deletes all occurances of specified substring in a String}
Function DeleteSubStringInString(substring,InputString: String): String;
Var
  CharPos : Integer;
Begin
  Result := InputString;
  While True Do
  Begin
    CharPos := Pos(substring,InputString);
    If Not (CharPos = 0) Then
      Delete(InputString,CharPos,length(substring))
    Else
      Break;
  End;
  Result := InputString;
End;

{!~ Deletes all occurances of specified substring in a String and is case
insensitive.}
Function DeleteSubStringInStringNoCase(substring,InputString: String): String;
Var
  CharPos : Integer;
  l       : Integer;
  U_S     : String;
Begin
  Result := InputString;
  l      := Length(SubString);
  U_S    := UpperCase(SubString);
  While True Do
  Begin
    CharPos := Pos(U_S,UpperCase(InputString));
    If Not (CharPos = 0) Then
      Delete(InputString,CharPos,l)
    Else
      Break;
  End;
  Result := InputString;
End;

{!~ Throws away all keys except a-z and A-Z}
Procedure KeyPressOnlyAToZ(Var Key: Char);
Begin
  Case Key Of
    'a': Exit;
    'b': Exit;
    'c': Exit;
    'd': Exit;
    'e': Exit;
    'f': Exit;
    'g': Exit;
    'h': Exit;
    'i': Exit;
    'j': Exit;
    'k': Exit;
    'l': Exit;
    'm': Exit;
    'n': Exit;
    'o': Exit;
    'p': Exit;
    'q': Exit;
    'r': Exit;
    's': Exit;
    't': Exit;
    'u': Exit;
    'v': Exit;
    'w': Exit;
    'x': Exit;
    'y': Exit;
    'z': Exit;
    'A': Exit;
    'B': Exit;
    'C': Exit;
    'D': Exit;
    'E': Exit;
    'F': Exit;
    'G': Exit;
    'H': Exit;
    'I': Exit;
    'J': Exit;
    'K': Exit;
    'L': Exit;
    'M': Exit;
    'N': Exit;
    'O': Exit;
    'P': Exit;
    'Q': Exit;
    'R': Exit;
    'S': Exit;
    'T': Exit;
    'U': Exit;
    'V': Exit;
    'W': Exit;
    'X': Exit;
    'Y': Exit;
    'Z': Exit;
    #8 : Exit; {Backspace}
  End;
  Key := #0;   {Throw the key away}
End;

{!~ Throws away all keys except 0-9,-,+,.}
Procedure KeyPressOnlyNumbers(Var Key: Char);
Begin
  Case Key Of
    '0': Exit;
    '1': Exit;
    '2': Exit;
    '3': Exit;
    '4': Exit;
    '5': Exit;
    '6': Exit;
    '7': Exit;
    '8': Exit;
    '9': Exit;
    '-': Exit;
    '+': Exit;
    '.': Exit;
    #8 : Exit; {Backspace}
  End;
  Key := #0;   {Throw the key away}
End;

{!~ Throws away all keys except 0-9}
Procedure KeyPressOnlyNumbersAbsolute(Var Key: Char);
Begin
  Case Key Of
    '0': Exit;
    '1': Exit;
    '2': Exit;
    '3': Exit;
    '4': Exit;
    '5': Exit;
    '6': Exit;
    '7': Exit;
    '8': Exit;
    '9': Exit;
    #8 : Exit; {Backspace}
  End;
  Key := #0;   {Throw the key away}
End;

{!~ Returns The Length Of The String}
Function Len(InputString: String): Integer;
Begin
  Result := Length(InputString);
End;

{!~ Returns a string converted to lower case}
Function Lower(InputString: String): String;
Begin
  Result := LowerCase(InputString);
End;

{!~ Throws away all characters except 0-9,-,+,.}
Function NumbersOnly(InputString: String): String;
Var
  NewString: String;
  L        : Integer;
  i        : Integer;
  C        : Char;
Begin
  Result    := InputString;
  NewString := '';
  L         := Length(InputString);
  For i:= 1 To L Do
  Begin
    C := InputString[i];
    KeyPressOnlyNumbers(C);
    If Not (C = #0) Then
    Begin
      NewString := NewString + C;
    End;
  End;
  Result    := NewString;
End;

{!~ Throws away all characters except 0-9}
Function NumbersOnlyAbsolute(InputString: String): String;
Var
  NewString: String;
  L        : Integer;
  i        : Integer;
  C        : Char;
Begin
  Result    := InputString;
  NewString := '';
  L         := Length(InputString);
  For i:= 1 To L Do
  Begin
    C := InputString[i];
    If Not(
         (C='+')  Or
         (C='-')  Or
         (C='.')  Or
         (C=',')) Then
    Begin
      KeyPressOnlyNumbers(C);
      If Not (C = #0) Then
      Begin
        If NewString = '0' Then NewString := '';
        NewString := NewString + C;
      End;
    End;
  End;
  Result    := NewString;
End;

{!~ Returns the Proper form of a string, i.e., each word
starts with a capitalized letter and all subsequent
letters are lowercase}
Function Proper(S : String): String;
Var
  Capitalize : Boolean;
  NewString  : String;
  i          : Integer;
  L          : Integer;
  C          : String;
Begin
  Result     := '';
  Capitalize := True;
  NewString  := '';
  L          := Length(S);
  If L = 0 Then Exit;

  For i := 1 To L Do
  Begin
    C := SubStr(S,i,1);
    If Capitalize Then
    Begin
      NewString := NewString + UpperCase(C);
    End
    Else
    Begin
      NewString := NewString + LowerCase(C);
    End;
    If (C = ' ') Or (C = '_') Then
    Begin
      Capitalize := True;
    End
    Else
    Begin
      Capitalize := False;
    End;
  End;
  Result     := NewString;
End;

{!~ Replaces all occurances of a character in a string
with a new character}
Function ReplaceCharInString(S,OldChar,NewChar :String): String;
Var
  NewString  : String;
  i          : Integer;
  L          : Integer;
  C          : String;
Begin
  Result     := '';
  NewString  := '';
  L          := Length(S);

  {If the string is empty then get out of here}
  If L = 0 Then Exit;

  {If the string doesn't have any occurances of the
  OldChar then get out of here}
  If Pos(UpperCase(OldChar),UpperCase(S)) = 0 Then
  Begin
    Result := S;
    Exit;
  End;

  For i := 1 To L Do
  Begin
    C := SubStr(S,i,1);
    If UpperCase(C) = UpperCase(OldChar) Then
    Begin
      NewString := NewString + NewChar;
    End
    Else
    Begin
      NewString := NewString + C;
    End;
  End;
  Result     := NewString;
End;

{!~ Replaces all occurances of a Character in a String}
Function ReplaceCharacterInString(
           OldChar,
           NewChar,
           InputString: String): String;
Var
  CharPos,L : Integer;
Begin
  Result := InputString;
  If OldChar = NewChar Then Exit;
  L := Length(InputString);
  While True Do
  Begin
    CharPos := Pos(OldChar,InputString);
    If Not (CharPos = 0) Then
    Begin
      If CharPos = 1 Then
      Begin
        {First Character}
        InputString := NewChar + SubStr(InputString,2,255);
      End
      Else
      Begin
        If CharPos = L Then
        Begin
          {Last Character}
          InputString := SubStr(InputString,1,L-1)+NewChar;
        End
        Else
        Begin
          {Middle Character}
          InputString :=
            SubStr(InputString,1,CharPos-1)+
            NewChar                        +
            SubStr(InputString,CharPos+1,255);
        End;
      End;
      Result := InputString;
    End
    Else
    Begin
      Break;
    End;
  End;
  Result := InputString;
End;

{!~
Replaces all occurances of specified substring in a String.  This will have problems if
the OldSubString is Contained in the NewSubstring.  This is case sensitive.
}
Function ReplaceSubStringInString(OldSubString,NewSubString,InputString: String): String;
Var
  CharPos : Integer;
  L_O     : Integer;
Begin
  Result := InputString;
  L_O    := Length(OldSubString);
  While True Do
  Begin
    CharPos := Pos(OldSubString,InputString);
    If Not (CharPos = 0) Then
    Begin
      Delete(InputString,CharPos,L_O);
      Insert(NewSubString,InputString,CharPos);
    End
    Else
    Begin
      Break;
    End;
  End;
  Result := InputString;
End;

{!~
Replaces all occurances of specified substring in a String.  This will have problems if
the OldSubString is Contained in the NewSubstring.  This is case insensitive.
}
Function ReplaceSubStringInStringNoCase(OldSubString,NewSubString,InputString: String): String;
Var
  CharPos : Integer;
  L_O     : Integer;
  U_O     : String;
Begin
  Result := InputString;
  L_O    := Length(OldSubString);
  U_O    := UpperCase(OldSubString);
  While True Do
  Begin
    CharPos := Pos(U_O,UpperCase(InputString));
    If Not (CharPos = 0) Then
    Begin
      Delete(InputString,CharPos,L_O);
      Insert(NewSubString,InputString,CharPos);
    End
    Else
    Begin
      Break;
    End;
  End;
  Result := InputString;
End;

{!~ Pads or truncates a String and Justifies Left if StrJustify=True}
Function StringPad(
  InputStr,
  FillChar: String;
  StrLen: Integer;
  StrJustify: Boolean): String;
Var
  TempFill: String;
  Counter : Integer;
Begin
  If Not (Length(InputStr) = StrLen) Then
  Begin
    If Length(InputStr) > StrLen Then
    Begin
      InputStr := SubStr(InputStr,1,StrLen);
    End
    Else
    Begin
      TempFill := '';
      For Counter := 1 To StrLen-Length(InputStr) Do
      Begin
        TempFill := TempFill + FillChar;
      End;
      If StrJustify Then
      Begin
        {Left Justified}
        InputStr := InputStr + TempFill;
      End
      Else
      Begin
        {Right Justified}
        InputStr := TempFill + InputStr ;
      End;
    End;
  End;
  Result := InputStr;
End;

{!~
All matches are added to the Stringlist.
}
Function String_GrepAllToStringList(
  Source                  : String;   //The input string
  StartTag                : String;   //The start tag
  EndTag                  : String;   //The end tag
  Containing              : String;   //A match must contain this string
  Var StringList          : TStringList;   //A List of Matches
  CaseSensitiveTags       : Boolean;  //True if tags are casesensitive
  CaseSensitiveContaining : Boolean   //True if Containing string is casesensitive
  ): Boolean;                         //True if a match was found
Var
  S                   : String;
  FoundMatch          : Boolean;
  BeforeString        : String;   //The substring prior to the match
  MatchWithTags       : String;   //The match string including tags
  MatchWithoutTags    : String;   //the match string without the tags
  AfterString         : String;   //The substring after the match with tags
Begin
  StringList.Clear;
  S         := Source;
  BeforeString        := '';      //The substring prior to the match
  MatchWithTags       := '';      //The match string including tags
  MatchWithoutTags    := '';      //the match string without the tags
  AfterString         := '';      //The substring after the match with tags
  FoundMatch:=
    String_Grep_Detail(
      S,                //Source                  : String;   //The input string
      StartTag,         //StartTag                : String;   //The start tag
      EndTag,           //EndTag                  : String;   //The end tag
      Containing,       //Containing              : String;   //A match must contain this string
      BeforeString,     //Var BeforeString        : String;   //The substring prior to the match
      MatchWithTags,    //Var MatchWithTags       : String;   //The match string including tags
      MatchWithoutTags, //Var MatchWithoutTags    : String;   //the match string without the tags
      AfterString,      //Var AfterString         : String;   //The substring after the match with tags
      CaseSensitiveTags,//CaseSensitiveTags       : Boolean;  //True if tags are casesensitive
      CaseSensitiveContaining);//CaseSensitiveContaining : Boolean   //True if Containing string is casesensitive
                        //): Boolean;                         //True if a match was found
  Result := FoundMatch;
  While FoundMatch Do
  Begin
    StringList.Add(Trim(MatchWithoutTags));
    S := AfterString;
    FoundMatch:=
      String_Grep_Detail(
        S,                //Source                  : String;   //The input string
        StartTag,         //StartTag                : String;   //The start tag
        EndTag,           //EndTag                  : String;   //The end tag
        Containing,       //Containing              : String;   //A match must contain this string
        BeforeString,     //Var BeforeString        : String;   //The substring prior to the match
        MatchWithTags,    //Var MatchWithTags       : String;   //The match string including tags
        MatchWithoutTags, //Var MatchWithoutTags    : String;   //the match string without the tags
        AfterString,      //Var AfterString         : String;   //The substring after the match with tags
        CaseSensitiveTags,//CaseSensitiveTags       : Boolean;  //True if tags are casesensitive
        CaseSensitiveContaining);//CaseSensitiveContaining : Boolean   //True if Containing string is casesensitive
                          //): Boolean;                         //True if a match was found
  End;
End;

{!~
Returns the contents of a string between two tags.  The tag
information is not returned.  Finding the tags is case sensitive.
}
Function String_Grep_Contents(Source, StartTag, EndTag: String): String;
Var
  Containing              : String;   //A match must contain this string
  BeforeString            : String;   //The substring prior to the match
  MatchWithTags           : String;   //The match string including tags
  MatchWithoutTags        : String;   //the match string without the tags
  AfterString             : String;   //The substring after the match with tags
  CaseSensitiveTags       : Boolean;  //True if tags are casesensitive
  CaseSensitiveContaining : Boolean;  //True if Containing string is casesensitive
Begin
  Containing              := '';      //A match must contain this string
  BeforeString            := '';      //The substring prior to the match
  MatchWithTags           := '';      //The match string including tags
  MatchWithoutTags        := '';      //the match string without the tags
  AfterString             := '';      //The substring after the match with tags
  CaseSensitiveTags       := False;   //True if tags are casesensitive
  CaseSensitiveContaining := False;   //True if Containing string is casesensitive
  String_Grep_Detail(
    Source,                  //Source                  : String;   //The input string
    StartTag,                //StartTag                : String;   //The start tag
    EndTag,                  //EndTag                  : String;   //The end tag
    Containing,              //Containing              : String;   //A match must contain this string
    BeforeString,            //Var BeforeString        : String;   //The substring prior to the match
    MatchWithTags,           //Var MatchWithTags       : String;   //The match string including tags
    MatchWithoutTags,        //Var MatchWithoutTags    : String;   //the match string without the tags
    AfterString,             //Var AfterString         : String;   //The substring after the match with tags
    CaseSensitiveTags,       //CaseSensitiveTags       : Boolean;  //True if tags are casesensitive
    CaseSensitiveContaining  //CaseSensitiveContaining : Boolean   //True if Containing string is casesensitive
    );                       //): Boolean;                         //True if a match was found
  Result := MatchWithoutTags;
End;

{!~
STRING_GREP_DETAIL

This is a full featured grep function.  All data associated
with the grep operation is returned.  The substring before the
match section is stored in the BeforeString variable.  The Match
Substring is stored in two variables.  The variable MatchwithTags
stores the match substring wrapped in the Start and End Tags.
The variable MatchWithoutTags stores the match substring without
the Start and End Tags. CaseSensitivity can be toggled for both
the tags and the Containing String using the booleans
CaseSensitiveTags and CaseSensitiveContaining. For a match to be
successful it must satisfy all criteria.  If the Containing String
is null this criteria is not applied.
}
Function String_Grep_Detail(
  Source                  : String;   //The input string
  StartTag                : String;   //The start tag
  EndTag                  : String;   //The end tag
  Containing              : String;   //A match must contain this string
  Var BeforeString        : String;   //The substring prior to the match
  Var MatchWithTags       : String;   //The match string including tags
  Var MatchWithoutTags    : String;   //the match string without the tags
  Var AfterString         : String;   //The substring after the match with tags
  CaseSensitiveTags       : Boolean;  //True if tags are casesensitive
  CaseSensitiveContaining : Boolean   //True if Containing string is casesensitive
  ): Boolean;                         //True if a match was found
Var
  P_StartTag      : Integer;
  P_EndTag        : Integer;
  P_Containing    : Integer;
  S               : String;
  //MaxCount        : Integer;
  Temp            : String;
  StartTagUpper   : String;
  EndTagUpper     : String;
  StartTagLen     : Integer;
  EndTagLen       : Integer;
  ContainingUpper : String;
Begin
  S                := Source;
  Result           := False;
  BeforeString     := '';
  MatchWithTags    := '';
  MatchWithoutTags := '';
  AfterString      := S;
  Temp             := '';
  StartTagUpper    := UpperCase(StartTag);
  EndTagUpper      := UpperCase(EndTag);
  StartTagLen      := Length(StartTag);
  EndTagLen        := Length(EndTag);
  ContainingUpper  := UpperCase(Containing);

  If CaseSensitiveTags Then
  Begin
    P_StartTag   := Pos(StartTag,S);
  End
  Else
  Begin
    P_StartTag   := Pos(StartTagUpper,UpperCase(S));
  End;
  If P_StartTag = 0 Then
  Begin
    Result := False;
    BeforeString     := Source;
    MatchWithTags    := '';
    MatchWithoutTags := '';
    AfterString      := '';
    Exit;
  End
  Else
  Begin
    BeforeString := BeforeString + Copy(S,1,P_StartTag-1);
    S := Copy(S,P_StartTag,Length(S)-P_StartTag+1);
    If CaseSensitiveTags Then
    Begin
      P_EndTag   := Pos(EndTag,S);
    End
    Else
    Begin
      P_EndTag   := Pos(EndTagUpper,UpperCase(S));
    End;
    If P_EndTag = 0 Then
    Begin
      Result := False;
      BeforeString     := Source;
      MatchWithTags    := '';
      MatchWithoutTags := '';
      AfterString      := '';
      Exit;
    End
    Else
    Begin
      Temp := Copy(S,StartTagLen+1,P_EndTag-StartTagLen-1);
      If Containing = '' Then
      Begin
        Result := True;
        MatchWithTags    := StartTag+Temp+EndTag;
        MatchWithoutTags := Temp;
        AfterString      := Copy(S,P_EndTag+EndTagLen,Length(S)-P_EndTag-EndTagLen+1);
        Exit;
      End;
      If CaseSensitiveContaining Then
      Begin
        P_Containing   := Pos(Containing,Temp);
      End
      Else
      Begin
        P_Containing   := Pos(ContainingUpper,UpperCase(Temp));
      End;
      If P_Containing = 0 Then
      Begin
        BeforeString := BeforeString + Copy(S,1,P_EndTag+EndTagLen-1);
        S := Copy(S,P_EndTag+EndTagLen,Length(S)-P_EndTag-EndTagLen+1);
      End
      Else
      Begin
        Result := True;
        MatchWithTags    := StartTag+Temp+EndTag;
        MatchWithoutTags := Temp;
        AfterString      := Copy(S,P_EndTag+EndTagLen,Length(S)-P_EndTag-EndTagLen+1);
        Exit;
      End;
    End;
  End;
End;

{!~
STRING_LINEFEED_FORMAT

The String_LineFeed_Format function adjusts all line breaks in the given
string "SourceString" to be true CR/LF sequences. The function changes any
CR characters not followed by a LF and any LF characters not preceded by a
CR into CR/LF pairs. It also converts LF/CR pairs to CR/LF pairs. The LF/CR
pair is common in Unix text files.
}
Function String_LineFeed_Format(SourceString : String): String;
Begin
  Result := AdjustLineBreaks(SourceString);
End;

{!~
Inserts a Carriage Return/Line Feed at the index position.
}
Function String_LineFeed_Insert(SourceString : String; Index : Integer): String;
Var
  L : Integer;
Begin
  Result := SourceString;
  L := Length(SourceString);
  If SourceString = '' Then
  Begin
    Result := #13 + #10;
    Exit;
  End;
  If Index > L Then
  Begin
    Result := SourceString + #13 + #10;
    Exit;
  End;
  If Index <= 1 Then
  Begin
    Result := #13 + #10 + SourceString;
    Exit;
  End;
  Result :=
    Copy(SourceString,1,Index-1)+
    #13+
    #10+
    Copy(SourceString,Index,L-(Index-1));
End;

{!~
STRING_REPLACE

Replace all occurances of OldSubString with NewSubString in SourceString
}
Function String_Replace(
  OldSubString : String;
  NewSubString : String;
  SourceString : String): String;
Var
  P    : Integer;
  S    : String;
  R    : String;
  LOld : Integer;
Begin
  S      := SourceString;
  R      := '';
  LOld   := Length(OldSubString);
  Result := S;
  If OldSubString = '' Then Exit;
  If SourceString = '' Then Exit;
  P := Pos(OldSubString,S);
  If P = 0 Then
  Begin
    R := S;
  End
  Else
  Begin
    While P <> 0 Do
    Begin
      Delete(S,P,LOld);
      R := R + Copy(S,1,P-1)+NewSubString;
      S := Copy(S,P,Length(S)-(P-1));
      P := Pos(OldSubString,S);
      If P = 0 Then R := R + S;
    End;
  End;
  Result := R;
End;

{!~
STRING_REPLACE_NOCASE

Replace all occurances of OldSubString with NewSubString in
SourceString ignoring case
}
Function String_Replace_NoCase(
  OldSubString : String;
  NewSubString : String;
  SourceString : String): String;
Var
  P    : Integer;
  S    : String;
  R    : String;
  LOld : Integer;
  UOld : String;
Begin
  S      := SourceString;
  R      := '';
  LOld   := Length(OldSubString);
  UOld   := UpperCase(OldSubString);
  Result := S;
  If OldSubString = '' Then Exit;
  If SourceString = '' Then Exit;
  P := Pos(UOld,UpperCase(S));
  If P = 0 Then
  Begin
    R := S;
  End
  Else
  Begin
    While P <> 0 Do
    Begin
      Delete(S,P,LOld);
      R := R + Copy(S,1,P-1)+NewSubString;
      S := Copy(S, P,Length(S)-(P-1));
      P := Pos(UOld,UpperCase(S));
      If P = 0 Then R := R + S;
    End;
  End;
  Result := R;
End;

{!~
STRING_REVERSE

Returns a string whose values are all reversed,i.e. , the
first character is last and the last is first.
}
Function String_Reverse(S : String): String;
Var
  i   : Integer;
Begin
  Result := '';
  For i := Length(S) DownTo 1 Do
  Begin
    Result := Result + Copy(S,i,1);
  End;
End;

{!~ Returns a SubString of a String.
Can only handle strings up to 255 characters.}
Function SubStr(InputString: String; StartPos, StringLength: Byte): String;
Var

{$IFDEF WIN32}
  InString: ShortString;
  OutPutString: ShortString;
  LenInputString: Byte;
  Counter: Byte;
  OutputStringWas : ShortString;
{$ELSE}
  InString: String;
  OutPutString: String;
  LenInputString: Byte;
  Counter: Byte;
  OutputStringWas : String;
{$ENDIF}
  BreakOut : Boolean;
Begin
  Result := '';
  If InputString = '' Then Exit;
  BreakOut := False;
  If (StartPos < 0) Then StartPos := 1;

{$IFDEF WIN32}
  InString := ShortString(InputString);
{$ELSE}
  InString := InputString;
{$ENDIF}

  LenInputString := Length(InString);

  If StartPos > LenInputString Then
  Begin
    Result := '';
    Exit;
  End;
  If StringLength <= 0 Then
  Begin
    Result := '';
    Exit;
  End;

  If (StartPos+StringLength) > LenInputString Then
    StringLength := LenInputString-StartPos+1;

  OutPutString[0] := Chr(StringLength);

  For Counter := StartPos To (StartPos+StringLength-1) Do
  Begin
    OutputStringWas := OutputString;
    Try
      OutputString[Counter-StartPos+1]:=InputString[Counter];
    Except
      OutputString := OutputStringWas + 'zzz';
      Result := String(OutPutString);
      BreakOut := True;
    End;
    If BreakOut Then Exit;
  End;

{$IFDEF WIN32}
  Result := String(OutPutString);
{$ELSE}
  Result := OutPutString;
{$ENDIF}

End;

{!~ Trims blank spaces from both sides of the string}
Function TrimBlanksFromEnds(InputString: String): String;
Begin
  If InputString = '' Then
  Begin
    Result := '';
    Exit;
  End;
  InputString := TrimBlanksLeft(InputString);
  If InputString = '' Then
  Begin
    Result := '';
    Exit;
  End;
  InputString := TrimBlanksRight(InputString);
  Result := InputString;
End;

{!~ Trims blank spaces from the left of the string}
Function TrimBlanksLeft(InputString: String): String;
Var
  i : Integer;
Begin
  For i := 1 To Length(InputString) Do
  Begin
    If InputString[i] = ' ' Then
    Begin
      Delete(InputString,1,1);
    End
    Else
    Begin
      Break;
    End;
  End;
  Result := InputString;
End;

{!~ Trims blank spaces from the right of the string}
Function TrimBlanksRight(InputString: String): String;
Var
  Counter : Integer;
Begin
  Counter := 1;
  Result  := InputString;
  While True Do
  Begin
    If SubStr(InputString,Length(InputString),1) = ' ' Then
    Begin
      InputString := SubStr(InputString,1,Length(InputString)-1);
    End
    Else
    Begin
      Break;
    End;
    Counter := Counter + 1;
    If Counter > 253 Then Break;
  End;
  Result := InputString;
End;

{!~ Converts String To UpperCase}
Function Upper(InputString: String): String;
Begin
  Result := UpperCase(InputString);
End;

End.
{</PRE></BODY></HTML>}
