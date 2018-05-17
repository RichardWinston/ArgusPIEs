unit GetMODFLOWLayerFunction;

interface

uses SysUtils, stdctrls, AnePIE;

procedure GetMODFLOW_Layer (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses Variables, ModflowUnit, ParamArrayUnit, ANE_LayerUnit, ANECB, ArgusFormUnit;

procedure GetMODFLOW_Layer (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  param2_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  TopElev : ANE_DOUBLE;
  param3_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  BotElev : ANE_DOUBLE;
  param4_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Elev : ANE_DOUBLE;
  result : ANE_INT32;
  param : PParameter_array;
  UnitIndex : integer;
begin
//  CurrentModelHandle := funHandle;
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;
{  ANE_GetPIEProjectHandle(funHandle, @frmMODFLOW );
  frmMODFLOW.CurrentModelHandle := funHandle;  }

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
  param2_ptr :=  param^[1];
  TopElev :=  param2_ptr^;
  param3_ptr :=  param^[2];
  BotElev :=  param3_ptr^;
  param4_ptr :=  param^[3];
  Elev :=  param4_ptr^;

  result := 0;
  For UnitIndex := 1 to AUnit -1 do
  begin
    if frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex]='Yes' then
    begin
      result := result + StrToInt(frmMODFLOW.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
    end;

  end;

  if frmMODFLOW.dgGeol.Cells[Ord(nuiSim),AUnit]='Yes' then
  begin
    result := result + Trunc((TopElev-Elev)/(TopElev-BotElev)*
      StrToInt(frmMODFLOW.dgGeol.Cells[Ord(nuiVertDisc),AUnit]));
    if not (Elev=BotElev) then
    begin
      Inc(result);
    end;
  end;


  ANE_INT32_PTR(reply)^ := result;
end;

end.
