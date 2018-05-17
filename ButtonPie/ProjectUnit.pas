unit ProjectUnit;

interface

uses Dialogs, sysutils, Controls,
  
  ProjectPIE, AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

function GSimpleExportNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

implementation

uses ProjectFunctions, frmProjectUnit, ANECB;

const
  kMaxPIEDesc = 20;

var
gSimpleProjectPDesc : ProjectPIEDesc ;
gSimpleProjectDesc : ANEPIEDesc ;

gPIEDesc : Array [0..kMaxPIEDesc-1] of ^ANEPIEDesc;



function GSimpleExportNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

var
  layerStructure : ANE_STR;
begin
{
Chr(9) is a tab character.

Chr(10) is the new-line character.

\t represents the tab character in C++ and thus is interpreted
as a tab in the template.
}
  layerStructure :=  PChar(
'Layer:' + Chr(10) + 
'{' + Chr(10) + 
Chr(9) + 'Name: "Simple Domain"' + Chr(10) +
Chr(9) + 'Units: "Density"' + Chr(10) +
Chr(9) + 'Type: "Domain"' + Chr(10) + 
Chr(9) + 'Visible: Yes' + Chr(10) + 
Chr(9) + 'Interpretation Method: Nearest' + Chr(10) + 
Chr(9) + '' + Chr(10) +
Chr(9) + 'Parameter: ' + Chr(10) + 
Chr(9) + '{' + Chr(10) +
Chr(9) + Chr(9) + 'Name: "Density"' + Chr(10) +
Chr(9) + Chr(9) + 'Units: "Units"' + Chr(10) + 
Chr(9) + Chr(9) + 'Value Type: Real' + Chr(10) + 
Chr(9) + Chr(9) + 'Value: "0"' + Chr(10) + 
Chr(9) + Chr(9) + 'Parameter Type: Layer' + Chr(10) + 
Chr(9) + '}' + Chr(10) +
'}' + Chr(10) +
'Layer:' + Chr(10) +
'{' + Chr(10) +
Chr(9) + 'Name: "Simple Density"' + Chr(10) +
Chr(9) + 'Units: "Units"' + Chr(10) +
Chr(9) + 'Type: "Information"' + Chr(10) +
Chr(9) + 'Visible: Yes' + Chr(10) +
Chr(9) + 'Interpretation Method: Nearest' + Chr(10) +
Chr(9) + '' + Chr(10) +
Chr(9) + 'Parameter: ' + Chr(10) +
Chr(9) + '{' + Chr(10) +
Chr(9) + Chr(9) + 'Name: "Simple Density"' + Chr(10) +
Chr(9) + Chr(9) + 'Units: "Units"' + Chr(10) +
Chr(9) + Chr(9) + 'Value Type: Real' + Chr(10) +
Chr(9) + Chr(9) + 'Value: "0"' + Chr(10) +
Chr(9) + Chr(9) + 'Parameter Type: Layer' + Chr(10) +
Chr(9) + '}' + Chr(10) +
'}' + Chr(10) +
'Layer:' + Chr(10) +
'{' + Chr(10) +
Chr(9) + 'Name: "SimpleGrid"' + Chr(10) +
Chr(9) + 'Units: "Units"' + Chr(10) +
Chr(9) + 'Type: "Grid"' + Chr(10) +
Chr(9) + 'Visible: Yes' + Chr(10) +
Chr(9) + 'Domain Layer: "Simple Domain"' + Chr(10) +
Chr(9) + 'Density Layer: "Simple Density"' + Chr(10) +
Chr(9) + '' + Chr(10) +
Chr(9) + 'Template: ' + Chr(10) +
Chr(9) + '{' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "File: $BaseName$"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NumRows(); [I8]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NumColumns(); [I8]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NumBlockParameters()+1 [I8]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLoop: Rows"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NthRowPos($Row$) [F8.2]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd loop"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLoop: Columns"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NthColumnPos($Column$) [F8.2]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd loop"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tMatrix: BlockIsActive() [I1]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLoop: Block Parameters"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: \"# $Parameter$\""' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tMatrix: $Parameter$ [F8.2]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd loop"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd file"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: ""' + Chr(10) +
Chr(9) + '}' + Chr(10) +
'}'+ Chr(10) + Chr(10) );

	rLayerTemplate^ := layerStructure;

	result := True;

end; { GSimpleExportTemplate }

var
  Counter : integer = 0;

function ButtonTest(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR;
    request : ANE_INT32; layer : ANE_PTR; paramType : EPIEParameterType;
    numParametrs : ANE_INT32; parameters : ANE_INT32_PTR;
    curParamIndex: ANE_INT32; numSelectedObjects : ANE_INT32 ;
    selectedObjects : ANE_PTR_PTR; curObjectIndex : ANE_INT32;
    ptr : ANE_PTR_PTR) : ANE_INT32;  cdecl;
const
  ButtonText : ANE_STR = 'Button Test';
var
  NewLayerHandle : ANE_PTR;
begin
  try
  case request of
    Ord(kOIDWhatToDo):
    begin
      NewLayerHandle := ANE_LayerGetHandleByName(aneHandle, 'Grid');
      if (layer = NewLayerHandle) then
      begin
//        ShowMessage('Argh, It''s gonna crash. (The other layer doesn''t cause this problem.)');
        ptr^ := ButtonText;
        result := Ord(kOIDDoAddButtonConstString);
      end
      else
      begin
        NewLayerHandle := ANE_LayerGetHandleByName(aneHandle, 'New Information Layer');
        if (layer = NewLayerHandle) then
        begin
//        ShowMessage('So why is this OK if the other layer has such a problem?)');
          ptr^ := ButtonText;
{          frmProject := PIEHandle;
          frmProject.CurrentModelHandle := aneHandle;
          frmProject.ShowModal; }

          result := Ord(kOIDDoAddButtonConstString);
//          result := Ord(kOIDDoNothing);
        end
        else
        begin
          ptr^ := ButtonText;
          result := Ord(kOIDDoNormal);
        end;
      end;
    end;
    Ord(kOIDShouldHiliteButton):
    begin
      Inc(Counter);
      if Odd(Counter) then
      begin
        result := 1;
      end
      else
      begin
        result := 0;
      end;
    end;
    Ord(kOIDButton):
    begin
      frmProject := PIEHandle;
      frmProject.CurrentModelHandle := aneHandle;
//      frmProject.Show;
//        frmProject.Width := 0;
//        frmProject.Height := 0;

      frmProject.atest.AutoPopup := False;
      frmProject.atest.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
//      frmProject.ShowModal;
      result := 1;
    end;
    Ord(kOIDCleanup):
    begin
      result := 1;
    end;


  end;
  Except on E: Exception do
    begin
      ShowMessage('Argh: ' + E.Message);
    end;
  end;
end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gSimpleProjectPDesc.version := PROJECT_PIE_VERSION;
	gSimpleProjectPDesc.name := 'Button Test Project';
	gSimpleProjectPDesc.projectFlags := 0;
	gSimpleProjectPDesc.createNewProc := GProjectNew;
	gSimpleProjectPDesc.editProjectProc := GEditForm;
	gSimpleProjectPDesc.cleanProjectProc := GClearForm;
	gSimpleProjectPDesc.saveProc := GSaveForm;
	gSimpleProjectPDesc.loadProc := GLoadForm;
	gSimpleProjectPDesc.oidProc := ButtonTest;

	gSimpleProjectDesc.name  := 'Button Test Project';
	gSimpleProjectDesc.PieType :=  kProjectPIE;
	gSimpleProjectDesc.descriptor := @gSimpleProjectPDesc;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gSimpleProjectDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gPIEDesc;

end;

end.
