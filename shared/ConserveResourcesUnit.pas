unit ConserveResourcesUnit;

interface

uses Windows, Classes, Controls, Forms, comctrls;

Procedure FreePageControlResources(const APageControl : TPageControl;
  const FormHandle : HWND);
  
Procedure FreeFormResources(const AForm : TForm);

implementation

type
  TMyWinControl = class(TWinControl);

Procedure FreePageControlResources(const APageControl : TPageControl;
  const FormHandle : HWND);
var
  Index : integer;
begin
  Exit;
//  LockWindowUpdate prevents any drawing in a given window}
  LockWindowUpdate(FormHandle);
  with APageControl do
  begin
    for Index := 0 to PageCount -1 do
    begin
      // DestroyHandle is protected so a typecast is required
      // to expose it.
      // The handles will be automatically recreated when needed.
      if Pages[Index] <> ActivePage then
        TMyWinControl(Pages[Index]).DestroyHandle;
    end;
  end;
  {Release the Lock on the Form so any Form drawing can work}
  LockWindowUpdate(0);
end;

Procedure FreeFormResources(const AForm : TForm);
var
  AComponent : TComponent;
  Index : integer;
begin
  for Index := 0 to AForm.ComponentCount -1 do
  begin
    AComponent := AForm.Components[Index];
    if AComponent is TPageControl then
    begin
      FreePageControlResources(TPageControl(AComponent), AForm.Handle);
    end;
  end;
end;

end.
