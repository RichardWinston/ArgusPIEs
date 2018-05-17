unit EditSelection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, AnePIE, ArgusDataEntry;

type
  TfrmUserResponse = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    adeResponse: TArgusDataEntry;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    procedure SetQuestion(AMessage : string);
    procedure SetResponse(Response : Double);  overload;
    procedure SetResponse(Response : Integer); overload;
    { Public declarations }
  end;

var
  frmUserResponse: TfrmUserResponse;

procedure GPIEGetEditFloatResponseFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEGetEditIntegerResponseFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

{$R *.DFM}

Uses OkCancelUnit;

procedure GPIEGetEditFloatResponseFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AMessage : ANE_STR;
  Response_Ptr : ANE_DOUBLE_PTR;
  Response : ANE_DOUBLE;
  param : PParameter_array;
  result : ANE_DOUBLE;
  Param_Ptr : ANE_DOUBLE_PTR;
  AParam : ANE_DOUBLE;
begin
  Try
    begin
      if frmUserResponse = nil then
      begin
        frmUserResponse := TfrmUserResponse.Create(Application);
      end;
      param := @parameters^;
      AMessage :=  param^[0];
      Response_Ptr :=  param^[1];
      Response := Response_Ptr^;
      frmUserResponse.adeResponse.DataType := dtReal;
      frmUserResponse.SetQuestion(String(AMessage));
      frmUserResponse.SetResponse(Response);
      if numParams > 2 then
      begin
        Param_Ptr :=  param^[2];
        AParam :=  Param_Ptr^;
        frmUserResponse.adeResponse.Min := AParam;
//        if AParam > 0 then
//        begin
//          frmUserResponse.adeResponse.Text := FloatToStr(AParam);
//        end;
        frmUserResponse.adeResponse.CheckMin := True;
      end;
      if numParams > 3 then
      begin
        Param_Ptr :=  param^[3];
        AParam :=  Param_Ptr^;
        frmUserResponse.adeResponse.Max := AParam;
//        if AParam < 0 then
//        begin
//          frmUserResponse.adeResponse.Text := FloatToStr(AParam);
//        end;
        frmUserResponse.adeResponse.CheckMax := True;
      end;
      if frmUserResponse.ShowModal = mrOK then
      begin
        Response := StrToFloat(frmUserResponse.adeResponse.Text);
      end;
      result := Response;
      frmUserResponse.Free;
      frmUserResponse := nil;
      ANE_DOUBLE_PTR(reply)^ := result;
    end
  except On Exception do
    begin
      ShowMessage('Unknown error in OkCancel PIE');
    end;
  end;
end;

procedure GPIEGetEditIntegerResponseFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AMessage : ANE_STR;
  Response_Ptr : ANE_INT32_PTR;
  Response : ANE_INT32;
  param : PParameter_array;
  result : ANE_INT32;
//  Index : integer;
  Param_Ptr : ANE_INT32_PTR;
  AParam : ANE_INT32;
begin
  Try
    begin
      if frmUserResponse = nil then
      begin
        frmUserResponse := TfrmUserResponse.Create(Application);
      end;
      param := @parameters^;
      AMessage :=  param^[0];
      Response_Ptr :=  param^[1];
      Response := Response_Ptr^;
      frmUserResponse.adeResponse.DataType := dtInteger;
      frmUserResponse.SetQuestion(String(AMessage));
      frmUserResponse.SetResponse(Response);
      if numParams > 2 then
      begin
        Param_Ptr :=  param^[2];
        AParam :=  Param_Ptr^;
        frmUserResponse.adeResponse.Min := AParam;
        if AParam > 0 then
        begin
          frmUserResponse.adeResponse.Text := IntToStr(AParam);
        end;
        frmUserResponse.adeResponse.CheckMin := True;
      end;
      if numParams > 3 then
      begin
        Param_Ptr :=  param^[3];
        AParam :=  Param_Ptr^;
        frmUserResponse.adeResponse.Max := AParam;
        if AParam < 0 then
        begin
          frmUserResponse.adeResponse.Text := IntToStr(AParam);
        end;
        frmUserResponse.adeResponse.CheckMax := True;
      end;
      if frmUserResponse.ShowModal = mrOK then
      begin
        Response := StrToInt(frmUserResponse.adeResponse.Text);
      end;
      result := Response;
      frmUserResponse.Free;
      frmUserResponse := nil;
      ANE_INT32_PTR(reply)^ := result;
    end
  except On Exception do
    begin
      ShowMessage('Unknown error in OkCancel PIE');
    end;
  end;
end;

{ TfrmUserResponse }

procedure TfrmUserResponse.SetQuestion(AMessage: string);
begin
  Label1.Caption := AMessage;
end;

procedure TfrmUserResponse.SetResponse(Response: Double);
begin
  adeResponse.Text := FloatToStr(Response);
end;

procedure TfrmUserResponse.SetResponse(Response: Integer);
begin
  adeResponse.Text := IntToStr(Response);
end;

end.
