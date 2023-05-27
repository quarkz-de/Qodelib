unit Qodelib.Trackbars;

interface

uses
  System.SysUtils, System.Classes, System.Types,
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl,
  Vcl.ComCtrls;

type
  TTrackBar = class(Vcl.ComCtrls.TTrackBar)
  private
    procedure WMLButtonDown(var Msg: TMessage); message WM_LBUTTONDOWN;
  end;

implementation

procedure TTrackBar.WMLButtonDown(var Msg: TMessage);
var
  ChannelRect, SliderRect: TRect;
  SliderWidth: Word;
  Pt: TPoint;
begin
  ZeroMemory(@SliderRect, SizeOf(SliderRect));
  SendMessage(Handle, TBM_GETTHUMBRECT, 0, DWord(@SliderRect));
  ZeroMemory(@ChannelRect, SizeOf(ChannelRect));
  SendMessage(Handle, TBM_GETCHANNELRECT, 0, DWord(@ChannelRect));
  if Orientation = trHorizontal then
    begin
      Pt := Point(msg.LParamLo, msg.LParamHi);
      SliderWidth := (SliderRect.Right - SliderRect.Left) div 2;
      ChannelRect.Top := SliderRect.Top;
      ChannelRect.Bottom := SliderRect.Bottom;
    end
  else
    begin
      Pt := Point(msg.LParamHi, msg.LParamLo);
      SliderWidth := (SliderRect.Bottom - SliderRect.Top) div 2;
      ChannelRect.Top := SliderRect.Left;
      ChannelRect.Bottom := SliderRect.Right;
    end;

  if PtInRect(SliderRect, Point(msg.LParamLo, msg.LParamHi)) then
    inherited
  else if Winapi.Windows.PtInRect(ChannelRect, Pt) then
    begin
      Inc(ChannelRect.Left, SliderWidth);
      Dec(ChannelRect.Right, SliderWidth);
      self.Position := round((Pt.X - ChannelRect.Left) * self.Max / (ChannelRect.Right - ChannelRect.Left));
      inherited;
    end;
end;

end.
