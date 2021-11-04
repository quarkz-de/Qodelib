unit Qodelib.Forms;

interface

uses
  Winapi.Windows,
  Vcl.Forms;

type
  TFormCornerType = (fctDefault, fctDoNotRound, fctRound, fctRoundSmall);

  TQzForm = class(TForm)
  private
    FCornerType: TFormCornerType;
    procedure SetCornerType(Value: TFormCornerType);
  public
    class procedure ChangeCornerType(const AForm: HWND;
      const AType: TFormCornerType);  overload;
    class procedure ChangeCornerType(const AForm: TCustomForm;
      const AType: TFormCornerType); overload;
  published
    property CornerType: TFormCornerType read FCornerType write SetCornerType
      default fctDefault;
  end;

implementation

uses
  Winapi.Dwmapi;

const
  DWMWCP_DEFAULT = 0;
  DWMWCP_DONOTROUND = 1;
  DWMWCP_ROUND = 2;
  DWMWCP_ROUNDSMALL = 3;
  DWMWA_WINDOW_CORNER_PREFERENCE = 33;

{ TQzForm }

procedure TQzForm.SetCornerType(Value: TFormCornerType);
begin
  if Value <> FCornerType then
    begin
      FCornerType := Value;
      ChangeCornerType(self, Value);
    end;
end;

class procedure TQzForm.ChangeCornerType(const AForm: HWND;
  const AType: TFormCornerType);
var
  AttributeValue: Cardinal;
begin
  case AType of
    fctDefault:
      AttributeValue := DWMWCP_DEFAULT;
    fctDoNotRound:
      AttributeValue := DWMWCP_DONOTROUND;
    fctRound:
      AttributeValue := DWMWCP_ROUND;
    fctRoundSmall:
      AttributeValue := DWMWCP_ROUNDSMALL;
    else
      AttributeValue := DWMWCP_DEFAULT;
  end;

  Winapi.Dwmapi.DwmSetWindowAttribute(AForm, DWMWA_WINDOW_CORNER_PREFERENCE,
    @AttributeValue, SizeOf(AttributeValue));
end;

class procedure TQzForm.ChangeCornerType(const AForm: TCustomForm;
  const AType: TFormCornerType);
begin
  AForm.HandleNeeded;
  ChangeCornerType(AForm.Handle, AType);
end;

end.