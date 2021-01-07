unit Qodelib.HighDpi;

interface

uses
  Winapi.Windows,
  Vcl.Controls, Vcl.Forms;

type
  THighDpiScaling = class
  public
    class procedure ScaleToParent(const AControl, AParent: TWinControl);
  end;

implementation

{ THighDpiScaling }

class procedure THighDpiScaling.ScaleToParent(const AControl, AParent: TWinControl);
begin
  AControl.Parent := AParent;
  AControl.Left := MulDiv(AControl.Left, Screen.PixelsPerInch, 96);
  AControl.Top := MulDiv(AControl.Top, Screen.PixelsPerInch, 96);
  AControl.Height := MulDiv(AControl.Height, Screen.PixelsPerInch, 96);
  AControl.Width := MulDiv(AControl.Width, Screen.PixelsPerInch, 96);
  AControl.ScaleBy(Screen.PixelsPerInch, 96);
end;

end.