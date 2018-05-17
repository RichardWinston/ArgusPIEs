unit RadioSelectionUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, AnePIE;

type
  TfrmRadio = class(TForm)
    pnlBottom: TPanel;
    btnOK: TBitBtn;
    rgChoices: TRadioGroup;
    pnlTop: TPanel;
    lblQuestion: TLabel;
    btnCancel: TButton;
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AddChoice(AString: String);
    procedure SetQuestion(AString: String);
    function GetSelection: integer;
    procedure SetChoicesHeight(Height: integer);
    procedure SetQuestionHeight(Height: integer);
    procedure SetWidth(Width: integer);
    { Public declarations }
  end;

var
  frmRadio: TfrmRadio;

procedure GPIEAddRadioChoiceFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEGetRadioChoiceFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


procedure GPIERadioChoiceFreeFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
                                
implementation

{$R *.DFM}

uses OkCancelUnit;

procedure TfrmRadio.AddChoice(AString : String);
begin
  rgChoices.Items.Add(AString);
end;

procedure TfrmRadio.FormResize(Sender: TObject);
begin
  btnOK.Left := pnlBottom.Width - btnOK.Width - 16;
  btnCancel.Left := btnOK.Left - btnCancel.Width - 16;
end;

function TfrmRadio.GetSelection : integer;
begin
  rgChoices.ItemIndex := 0;
  if ShowModal = mrOK then
  begin
    result := rgChoices.ItemIndex;
  end
  else
  begin
    result := -1;
  end;

end;

Procedure TfrmRadio.SetQuestion(AString : String);
begin
  lblQuestion.Caption := AString;
end;

Procedure TfrmRadio.SetQuestionHeight(Height : integer);
var
  ChoicesHeight : integer;
begin
  ChoicesHeight := rgChoices.Height;
  pnlTop.Height := Height;
  SetChoicesHeight(ChoicesHeight);
end;

Procedure TfrmRadio.SetChoicesHeight(Height : integer);
begin
  frmRadio.ClientHeight := Height + pnlBottom.Height + pnlTop.Height;
end;

Procedure TfrmRadio.SetWidth(Width : integer);
begin
  frmRadio.Width := Width;
end;

procedure GPIEAddRadioChoiceFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AMessage : ANE_STR;
  param : PParameter_array;
  result : ANE_BOOL;
  ParamIndex : integer;
begin
  Try
    begin
      param := @parameters^;
      if frmRadio = nil then
      begin
        frmRadio := TfrmRadio.Create(Application);
      end;

      for ParamIndex := 0 to numParams - 1 do
      begin
        AMessage :=  param^[ParamIndex];
        frmRadio.AddChoice(String(AMessage));
      end;

      result := True;
      ANE_BOOL_PTR(reply)^ := result;
    end
  except On Exception do
    begin
      ShowMessage('Unknown error in OkCancel PIE');
    end;
  end;
end;

procedure GPIEGetRadioChoiceFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AMessage : ANE_STR;
  param : PParameter_array;
  result : ANE_INT32;
  Index : integer;
  Param_Ptr : ANE_INT32_PTR;
  AParam : ANE_INT32;
begin
  Try
    begin
      if frmRadio = nil then
      begin
        frmRadio := TfrmRadio.Create(Application);
      end;
      param := @parameters^;
      AMessage :=  param^[0];
      frmRadio.SetQuestion(String(AMessage));
      for Index := 1 to numParams -1 do
      begin
        Param_Ptr :=  param^[Index];
        AParam :=  Param_Ptr^;
        Case Index of
          1:
            begin
              frmRadio.SetChoicesHeight(AParam);
            end;
          2:
            begin
              frmRadio.SetWidth(AParam);
            end;
          3:
            begin
              frmRadio.SetQuestionHeight(AParam);
            end;
          else
            begin
              Assert(False);
            end;
        end;
      end;
      result := frmRadio.GetSelection;
      frmRadio.Free;
      frmRadio := nil;
      ANE_INT32_PTR(reply)^ := result;
    end
  except On Exception do
    begin
      ShowMessage('Unknown error in OkCancel PIE');
    end;
  end;
end;

{procedure GPIESetRadioQuestionFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AMessage : ANE_STR;
  param : PParameter_array;
  result : ANE_BOOL;
begin
  Try
    begin
      param := @parameters^;
      AMessage :=  param^[0];
      if frmRadio = nil then
      begin
        frmRadio := TfrmRadio.Create(Application);
      end;
      frmRadio.SetQuestion(String(AMessage));
      result := True;
      ANE_BOOL_PTR(reply)^ := result;
    end
  except On Exception do
    begin
      ShowMessage('Unknown error in OkCancel PIE');
    end;
  end;
end;    }


procedure GPIERadioChoiceFreeFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
begin
  Try
    begin
      frmRadio.Free;
      frmRadio := nil;
      result := True;
      ANE_BOOL_PTR(reply)^ := result;
    end
  except On Exception do
    begin
      ShowMessage('Unknown error in OkCancel PIE');
    end;
  end;
end;

end.
