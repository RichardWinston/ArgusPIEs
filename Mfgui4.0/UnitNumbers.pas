unit UnitNumbers;

interface

Uses sysutils, Dialogs, contnrs, AnePIE;

type
  TGetUnit = Class(TObject)
  private
    Gotten : boolean;
    UnitNumber : integer;
    Count : integer;
  public
    Constructor CreateWithUnitNumber(AValue : integer);
    function GetUnit : integer;
    function GetUnits(UnitCount : integer) : integer;
  end;


procedure GGetUnitNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GetNextUnitNumber : integer;

implementation

uses ParamArrayUnit, ANE_LayerUnit, Variables, ArgusFormUnit;



function GetNextUnitNumber : integer;
begin
  result := frmModflow.GetNextUnitNumber
end;

function GetNextNUnitNumber(Count : integer) : integer;
begin
  result := frmModflow.GetNextNUnitNumber(Count);
end;



{ TGetUnit }

constructor TGetUnit.CreateWithUnitNumber(AValue: integer);
begin
  UnitNumber := AValue;
  Gotten := (UnitNumber > 1) and (UnitNumber <> 5) and (UnitNumber <> 6)
     and (UnitNumber <> 17)
     and ((UnitNumber < 96) or (UnitNumber > 99))
     and ((UnitNumber < 201) or (UnitNumber > 205))
     and ((UnitNumber < 401) or (UnitNumber > 405))
     and ((UnitNumber < 601) or (UnitNumber > 605))
     ;
end;

function TGetUnit.GetUnit: integer;
begin
  if not Gotten then
  begin
    UnitNumber := GetNextUnitNumber;
    Gotten := True;
  end;
  result := UnitNumber;
  Count := 1;
end;

function TGetUnit.GetUnits(UnitCount: integer): integer;
begin
  if not Gotten or (UnitCount > Count) then
  begin
    UnitNumber := GetNextNUnitNumber(UnitCount);
    Gotten := True;
    Count := UnitCount;
  end;
  result := UnitNumber;

end;


procedure GGetUnitNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param : PParameter_array;
  FileType : ANE_STR;
  FileTypeString : String;
  Param2Ptr : ANE_INT32_PTR;
  NumUnits : ANE_INT32;
begin
  result := -1;
  try
    if EditWindowOpen then
    begin
      MessageDlg('You can not export a ' +
      ' project if an edit box is open. Try again after'
      + ' correcting this problems.', mtError, [mbOK], 0);
    end
    else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try
        try
          frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
            as ModflowTypes.GetModflowFormType;

          param := @parameters^;
          FileType :=  param^[0];
          FileTypeString := String(FileType);

          if numParams > 1 then
          begin
            Param2Ptr := param^[1];
            NumUnits := Param2Ptr^;
            result := frmMODFLOW.GetNUnitNumbers(FileTypeString,NumUnits);
          end
          else
          begin
            result := frmMODFLOW.GetUnitNumber(FileTypeString);
          end;

        Except on E : Exception do
          begin
            result := -1;
            Beep;
            MessageDlg(E.Message, mtError, [mbOK], 0);
          end;
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 1
    end; // if EditWindowOpen else
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

end.
