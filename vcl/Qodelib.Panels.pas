unit Qodelib.Panels;

interface

uses
  System.Classes, System.Types,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Graphics, Vcl.Themes;

type
  TQzEdge = (qeTop, qeLeft, qeBottom, qeRight);
  TQzEdges = set of TQzEdge;

  TQzCustomPanel = class(TCustomPanel)
  private
    FEdges: TQzEdges;
    procedure SetEdges(Value: TQzEdges);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure Paint; override;
    property Edges: TQzEdges read FEdges write SetEdges default [qeTop, qeLeft, qeBottom, qeRight];
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TQzPanel = class(TQzCustomPanel)
  published
    property Edges;

    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderWidth;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property Padding;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property VerticalAlignment;
    property Visible;
    property StyleElements;
    property StyleName;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

{ TQzCustomPanel }

procedure TQzCustomPanel.AdjustClientRect(var Rect: TRect);
var
  BevelSize: Integer;
begin
  if qeTop in Edges then
    Inc(Rect.Top, BorderWidth);
  if qeRight in Edges then
    Dec(Rect.Right, BorderWidth);
  if qeBottom in Edges then
    Dec(Rect.Bottom, BorderWidth);
  if qeLeft in Edges then
    Inc(Rect.Left, BorderWidth);
end;

constructor TQzCustomPanel.Create(AOwner: TComponent);
begin
  inherited;
  ShowCaption := false;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BevelKind := bkNone;
  BorderWidth := 1;
  FEdges := [qeTop, qeLeft, qeBottom, qeRight];
end;

procedure TQzCustomPanel.Paint;
var
  Rect: TRect;
  TmpColor, BackgroundColor, BorderColor: TColor;
  Style: TCustomStyleServices;
  Details: TThemedElementDetails;
  X, Y: Integer;
begin
  Rect := ClientRect;

  BackgroundColor := Color;
  BorderColor := clBtnShadow;

  Style := StyleServices(Self);
  if Style.Enabled and (seClient in StyleElements) then
    begin
      BackgroundColor := Style.GetSystemColor(BackgroundColor);
      // Details := Style.GetElementDetails(tpPanelBackground);
      // if Style.GetElementColor(Details, ecFillColor, TmpColor) and (TmpColor <> clNone) then
      //   BackgroundColor := TmpColor;
    end;
  if Style.Enabled and (seBorder in StyleElements) then
    begin
      Details := Style.GetElementDetails(tpPanelBevel);
      if Style.GetElementColor(Details, ecEdgeShadowColor, TmpColor) and (TmpColor <> clNone) then
        BorderColor := TmpColor;
    end;

  Canvas.Pen.Width := BorderWidth;
  Canvas.Pen.Color := BorderColor;
  Canvas.Brush.Style := bsClear;
  Canvas.Brush.Color := BackgroundColor;
  Canvas.FillRect(Rect);

  if BorderWidth > 0 then
    begin
      X := (BorderWidth div 2);
      if Odd(BorderWidth) then
        Y := X
      else
        Y := X - 1;

      Inc(Rect.Left, X);
      Inc(Rect.Top, X);
      Dec(Rect.Bottom, Y + 1);
      Dec(Rect.Right, Y + 1);

      if qeTop in Edges then
        begin
          Canvas.MoveTo(Rect.Left, Rect.Top);
          Canvas.LineTo(Rect.Right, Rect.Top)
        end;
      if qeRight in Edges then
        begin
          Canvas.MoveTo(Rect.Right, Rect.Top);
          Canvas.LineTo(Rect.Right, Rect.Bottom)
        end;
      if qeBottom in Edges then
        begin
          Canvas.MoveTo(Rect.Right, Rect.Bottom);
          Canvas.LineTo(Rect.Left, Rect.Bottom)
        end;
      if qeLeft in Edges then
        begin
          Canvas.MoveTo(Rect.Left, Rect.Bottom);
          Canvas.LineTo(Rect.Left, Rect.Top)
        end;
    end;
end;

procedure TQzCustomPanel.SetEdges(Value: TQzEdges);
begin
  FEdges := Value;
  Realign;
  Invalidate;
end;

end.
