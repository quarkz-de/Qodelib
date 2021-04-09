unit Qodelib.DropdownForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.Types, System.Classes,
  Vcl.Controls, Vcl.Forms;

type
  TDropDownForm = class(TForm)
  private
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure CloseDropDown(const AApplyData: Boolean);
  protected
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoCreate; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Deactivate; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure ApplyFormData; virtual;
    procedure DiscardFormData; virtual;
  end;

  TDropDownFormClass = class of TDropDownForm;

  TDropDownFormController = class
  public
    class function DropDown(const AClass: TDropDownFormClass;
      const ASnapTo: TControl): TDropDownForm;
  end;

implementation

{ TDropDownForm }

procedure TDropDownForm.ApplyFormData;
begin

end;

procedure TDropDownForm.CloseDropDown(const AApplyData: Boolean);
begin
  if AApplyData then
    ApplyFormData
  else
    DiscardFormData;
  Close;
end;

procedure TDropDownForm.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;
begin
  inherited CreateParams(Params);
  Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TDropDownForm.Deactivate;
begin
  inherited;
  CloseDropDown(false);
end;

procedure TDropDownForm.DiscardFormData;
begin

end;

procedure TDropDownForm.DoClose(var Action: TCloseAction);
begin
  Action := caFree;
  inherited;
end;

procedure TDropDownForm.DoCreate;
begin
  inherited;
  DoubleBuffered := true;
  BorderStyle := bsNone;
  KeyPreview := true;
end;

procedure TDropDownForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      if Shift = [] then
        begin
          CloseDropDown(false);
          Key := 0;
        end;
    VK_RETURN:
      if Shift = [] then
        begin
          CloseDropDown(true);
          Key := 0;
        end;
  end;

  inherited;
end;

procedure TDropDownForm.WMMouseActivate(var Message: TWMMouseActivate);
begin
  Message.Result := MA_NOACTIVATE;
end;

{ TDropDownFormController }

class function TDropDownFormController.DropDown(const AClass: TDropDownFormClass;
  const ASnapTo: TControl): TDropDownForm;
const
  AnimationDuration = 200;
var
  Form: TDropDownForm;
  Origin: TPoint;
  ComboBoxAnimation: Boolean;
  I: Integer;
begin
  Form := AClass.Create(Application);
  Form.BorderStyle := bsNone;

  Form.Parent := nil;
  Form.PopupParent := GetParentForm(ASnapTo);

  Form.Position := poDesigned;
  Origin := Point(0, ASnapTo.Height);
  Origin := ASnapTo.ClientToScreen(Origin);
  Form.Left := Origin.X;
  Form.Top := Origin.Y;

  if not SystemParametersInfo(SPI_GETCOMBOBOXANIMATION, 0, @ComboBoxAnimation, 0) then
    ComboBoxAnimation := false;

  if ComboBoxAnimation then
    begin
      for I := 0 to Form.ControlCount - 1 do
        begin
          if Form.Controls[I] is TWinControl and Form.Controls[I].Visible and
            not TWinControl(Form.Controls[I]).HandleAllocated then
            begin
              TWinControl(Form.Controls[I]).HandleNeeded;
              SetWindowPos(TWinControl(Form.Controls[I]).Handle, 0, 0, 0, 0, 0,
                SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_SHOWWINDOW);
            end;
        end;
      AnimateWindow(Form.Handle, AnimationDuration, AW_VER_POSITIVE or AW_SLIDE or AW_ACTIVATE);
    end
  else
    ShowWindow(Form.Handle, SW_SHOWNOACTIVATE);

  Form.Visible := true;

  Result := Form;
end;

end.