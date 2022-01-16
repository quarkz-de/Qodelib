unit Qodelib.NavigationView;

interface

uses
  System.SysUtils, System.Classes,
  Winapi.Windows, Winapi.Messages,
  Vcl.ImgList, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls, Vcl.Controls,
  Vcl.CategoryButtons;

type
  TQzNavigationButtonItem = class;
  TQzNavigationButtonItemClass = class of TQzNavigationButtonItem;
  TQzNavigationButtonItems = class;
  TQzNavigationButtonItemsClass = class of TQzNavigationButtonItems;

  TQzNavigationButtonEvent = procedure(Sender: TObject; Index: Integer) of object;
  TQzNavigationButtonDrawEvent = procedure(Sender: TObject; Index: Integer;
    Canvas: TCanvas; Rect: TRect; State: TButtonDrawState) of object;
  TQzNavigationButtonDrawIconEvent = procedure(Sender: TObject; Index: Integer;
    Canvas: TCanvas; Rect: TRect; State: TButtonDrawState; var TextOffset: Integer) of object;
  TQzNavigationButtonReorderEvent = procedure(Sender: TObject; OldIndex, NewIndex: Integer) of object;

  TQzNavigationButtonOptions = set of (nboAllowReorder, nboGroupStyle, nboShowCaptions);

  TQzNavigationView = class(TCustomControl)
  private
    FDownIndex: Integer;
    FDragIndex: Integer;
    FDragStartPos: TPoint;
    FDragStarted: Boolean;
    FDragImageList: TDragImageList;
    FHiddenItems: Integer;
    FHotIndex: Integer;
    FInsertTop, FInsertBottom: Integer;
    FIgnoreUpdate: Boolean;
    FScrollBarMax: Integer;
    FPageAmount: Integer;
    FButtonOptions: TQzNavigationButtonOptions;
    FButtonHeight: Integer;
    FBorderStyle: TBorderStyle;
    FFocusIndex: Integer;
    FImageChangeLink: TChangeLink;
    FMouseInControl: Boolean;
    FPanPoint: TPoint;
    FOnButtonClicked: TQzNavigationButtonEvent;
    FOnClick: TNotifyEvent;
    FOnHotButton: TQzNavigationButtonEvent;
    FOnDrawIcon: TQzNavigationButtonDrawIconEvent;
    FOnDrawButton: TQzNavigationButtonDrawEvent;
    FOnBeforeDrawButton: TQzNavigationButtonDrawEvent;
    FOnAfterDrawButton: TQzNavigationButtonDrawEvent;
    FOnReorderButton: TQzNavigationButtonReorderEvent;
    FScrollBarShown: Boolean;
    FImages: TCustomImageList;
    FButtonItems: TQzNavigationButtonItems;
    FItemIndex: Integer;
    class constructor Create;
    class destructor Destroy;
    procedure AutoScroll(ScrollCode: TScrollCode);
    procedure ImageListChange(Sender: TObject);
    function CalcRowsSeen: Integer;
    procedure DoFillRect(const Rect: TRect; ACanvas: TCanvas);
    procedure ScrollPosChanged(ScrollCode: TScrollCode;
      ScrollPos: Integer);
    procedure SetOnDrawButton(const Value: TQzNavigationButtonDrawEvent);
    procedure SetOnDrawIcon(const Value: TQzNavigationButtonDrawIconEvent);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetButtonHeight(const Value: Integer);
    procedure SetButtonOptions(const Value: TQzNavigationButtonOptions);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetButtonItems(const Value: TQzNavigationButtonItems);
    procedure SetItemIndex(const Value: Integer);
    function IsStyleEnabled: Boolean;
    procedure ShowScrollBar(const Visible: Boolean);
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure CNKeydown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetDragIndex(const Value: Integer);
    procedure CheckImageIndexes;
  protected
    function CreateButton: TQzNavigationButtonItem; virtual;
    procedure CreateHandle; override;
    procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoEndDrag(Target: TObject; X: Integer; Y: Integer); override;
    procedure DoGesture(const EventInfo: TGestureEventInfo; var Handled: Boolean); override;
    procedure DoHotButton; dynamic;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DoReorderButton(const OldIndex, NewIndex: Integer);
    procedure DoStartDrag(var DragObject: TDragObject); override;
    procedure DragOver(Source: TObject; X: Integer; Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    procedure DrawButton(Index: Integer; Canvas: TCanvas;
      Rect: TRect; State: TButtonDrawState); virtual;
    procedure DoItemClicked(const Index: Integer); virtual;
    function GetButtonClass: TQzNavigationButtonItemClass; virtual;
    function GetButtonsClass: TQzNavigationButtonItemsClass; virtual;
    function IsTouchPropertyStored(AProperty: TTouchProperty): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure UpdateButton(const Index: Integer);
    procedure UpdateAllButtons;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property DragIndex: Integer read FDragIndex write SetDragIndex;
    property DragImageList: TDragImageList read FDragImageList;
    procedure DragDrop(Source: TObject; X: Integer; Y: Integer); override;
    function GetButtonRect(const Index: Integer): TRect;
    function GetDragImages: TDragImageList; override;
    function IndexOfButtonAt(const X, Y: Integer): Integer;
    procedure RemoveInsertionPoints;
    procedure ScrollIntoView(const Index: Integer);
    procedure SetInsertionPoints(const InsertionIndex: Integer);
    function TargetIndexAt(const X, Y: Integer): Integer;
    property Canvas;
  published
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property ButtonHeight: Integer read FButtonHeight write SetButtonHeight default 24;
    property ButtonOptions: TQzNavigationButtonOptions read FButtonOptions write SetButtonOptions default [nboShowCaptions];
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Height default 100;
    property Images: TCustomImageList read FImages write SetImages;
    property Items: TQzNavigationButtonItems read FButtonItems write SetButtonItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property ParentDoubleBuffered;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Touch;
    property Width default 100;
    property Visible;
    property StyleElements;
    property StyleName;
    property OnAfterDrawButton: TQzNavigationButtonDrawEvent read FOnAfterDrawButton write FOnAfterDrawButton;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnBeforeDrawButton: TQzNavigationButtonDrawEvent read FOnBeforeDrawButton write FOnBeforeDrawButton;
    property OnButtonClicked: TQzNavigationButtonEvent read FOnButtonClicked write FOnButtonClicked;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawButton: TQzNavigationButtonDrawEvent read FOnDrawButton write SetOnDrawButton;
    property OnDrawIcon: TQzNavigationButtonDrawIconEvent read FOnDrawIcon write SetOnDrawIcon;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnHotButton: TQzNavigationButtonEvent read FOnHotButton write FOnHotButton;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnReorderButton: TQzNavigationButtonReorderEvent read FOnReorderButton write FOnReorderButton;
    property OnStartDock;
    property OnStartDrag;
  end;

  TQzNavigationButtonItem = class(TBaseButtonItem)
  protected
    function GetNavigationView: TQzNavigationView;
    function GetCollection: TQzNavigationButtonItems;
    function GetNotifyTarget: TComponent; override;
    procedure SetCollection(const Value: TQzNavigationButtonItems); reintroduce;
    procedure CheckImageIndexAndName;
  public
    procedure ScrollIntoView; override;
    property Collection: TQzNavigationButtonItems read GetCollection write SetCollection;
  published
    property NavigationView: TQzNavigationView read GetNavigationView;
  end;

  TQzNavigationButtonItems = class(TCollection)
  private
    FNavigationView: TQzNavigationView;
    FOriginalID: Integer;
  protected
    function GetItem(Index: Integer): TQzNavigationButtonItem;
    procedure SetItem(Index: Integer; const Value: TQzNavigationButtonItem);
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(const NavigationView: TQzNavigationView); virtual;
    function Add: TQzNavigationButtonItem;
    function AddItem(Item: TQzNavigationButtonItem; Index: Integer): TQzNavigationButtonItem;
    procedure BeginUpdate; override;
    function Insert(Index: Integer): TQzNavigationButtonItem;
    property NavigationView: TQzNavigationView read FNavigationView;
    property Items[Index: Integer]: TQzNavigationButtonItem read GetItem write SetItem; default;
  end;

implementation

uses
{$IF DEFINED(CLR)}
  System.Security.Permissions, System.Threading, System.Runtime.InteropServices,
{$ENDIF}
  System.Types, System.UITypes,
  Vcl.Themes, Vcl.GraphUtil, Vcl.ExtCtrls;

const
  cScrollBarKind = SB_VERT;
  cScrollBuffer = 6;

{ TQzNavigationView }

procedure TQzNavigationView.Assign(Source: TPersistent);
begin
  if Source is TQzNavigationView then
    begin
      Items := TQzNavigationView(Source).Items;
      ButtonHeight := TQzNavigationView(Source).ButtonHeight;
      ButtonOptions := TQzNavigationView(Source).ButtonOptions;
    end
  else
    inherited;
end;

procedure TQzNavigationView.AutoScroll(ScrollCode: TScrollCode);

  function ShouldContinue(out Delay: Integer): Boolean;
  const
    cMaxDelay = 500;
  var
    CursorPoint: TPoint;
  begin
    { Are we autoscrolling up or down? }
    if ScrollCode = scLineDown then
      begin
        Result := FHiddenItems < FScrollBarMax;
        if Result then
          begin
            CursorPoint := ScreenToClient(Mouse.CursorPos);
            if (CursorPoint.X < 0) or (CursorPoint.X > Width) or
               (CursorPoint.Y > Height) or (CursorPoint.Y < Height - cScrollBuffer) then
              Result := False
            else if CursorPoint.Y < (Height - cScrollBuffer div 2) then
              Delay := cMaxDelay
            else
              Delay := cMaxDelay div 2;
          end;
      end
    else
      begin
        Result := FHiddenItems > 0;
        if Result then
          begin
            CursorPoint := ScreenToClient(Mouse.CursorPos);
            if (CursorPoint.X < 0) or (CursorPoint.X > Width) or
               (CursorPoint.Y < 0) or (CursorPoint.Y > cScrollBuffer) then
              Result := False
            else if CursorPoint.Y > (cScrollBuffer div 2) then
              Delay := cMaxDelay
            else
              Delay := cMaxDelay div 2;
          end;
      end;
  end;
var
  CurrentTime, StartTime, ElapsedTime: Longint;
  Delay: Integer;
begin
  FDragImageList.HideDragImage;
  RemoveInsertionPoints;
  FDragImageList.ShowDragImage;

  CurrentTime := 0;
  while (ShouldContinue(Delay)) do
  begin
    StartTime := GetCurrentTime;
    ElapsedTime := StartTime - CurrentTime;
    if ElapsedTime < Delay then
      Sleep(Delay - ElapsedTime);
    CurrentTime := StartTime;

    FDragImageList.HideDragImage;
    ScrollPosChanged(ScrollCode, 0);
    UpdateWindow(Handle);
    FDragImageList.ShowDragImage;
  end;
end;

function TQzNavigationView.CalcRowsSeen: Integer;
begin
  Result := ClientHeight div FButtonHeight;
end;

procedure TQzNavigationView.ChangeScale(M, D: Integer;
  isDpiChange: Boolean);
begin
  inherited;
  FButtonHeight := MulDiv(FButtonHeight, M, D);
  UpdateAllButtons;
end;

procedure TQzNavigationView.CheckImageIndexes;
var
  I: Integer;
begin
  if (FImages <> nil) and FImages.IsImageNameAvailable then
    for I := 0 to FButtonItems.Count - 1 do
      FButtonItems[I].CheckImageIndexAndName;
end;

procedure TQzNavigationView.CMHintShow(var Message: TCMHintShow);
var
  ItemIndex: Integer;
{$IF DEFINED(CLR)}
  LHintInfo: THintInfo;
{$ELSE}
  LHintInfo: PHintInfo;
{$ENDIF}
begin
  Message.Result := 1;
  if Message.HintInfo.HintControl = Self then
    begin
      ItemIndex := IndexOfButtonAt(Message.HintInfo.CursorPos.X, Message.HintInfo.CursorPos.Y);
      if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
        begin
          LHintInfo := Message.HintInfo;
          with LHintInfo{$IFNDEF CLR}^{$ENDIF} do
            begin
              if Items[ItemIndex].Hint <> '' then
                HintStr := Items[ItemIndex].Hint
              else
                HintStr := Items[ItemIndex].Caption;
            end;
          if (Items[ItemIndex].ActionLink <> nil) then
            Items[ItemIndex].ActionLink.DoShowHint(LHintInfo.HintStr);
          LHintInfo.CursorRect := GetButtonRect(ItemIndex);
{$IF DEFINED(CLR)}
          Message.HintInfo := LHintInfo;
{$ENDIF}
          Message.Result := 0;
        end;
    end;
end;

procedure TQzNavigationView.CNKeydown(var Message: TWMKeyDown);
var
  IncAmount: Integer;

  procedure FixIncAmount(const StartValue: Integer);
  begin
    if StartValue + IncAmount >= FButtonItems.Count then
      IncAmount := FButtonItems.Count - StartValue - 1
    else if StartValue + IncAmount < 0 then
      IncAmount := 0 - StartValue;
  end;

var
  NewIndex: Integer;
begin
  IncAmount := 0;

  if Message.CharCode = VK_DOWN then
    IncAmount := 1
  else if Message.CharCode = VK_UP then
    IncAmount := -1
  else if Message.CharCode = VK_LEFT then
    IncAmount := -1
  else if Message.CharCode = VK_RIGHT then
    IncAmount := 1
  else if Message.CharCode = VK_NEXT then
    IncAmount := CalcRowsSeen
  else if Message.CharCode = VK_PRIOR then
    IncAmount := -1 * CalcRowsSeen
  else if Message.CharCode = VK_HOME then
    begin
      if nboGroupStyle in ButtonOptions then
        IncAmount := -1*FItemIndex
      else
        IncAmount := -1*FFocusIndex;
    end
  else if Message.CharCode = VK_END then
    begin
      if nboGroupStyle in ButtonOptions then
        IncAmount := FButtonItems.Count - FItemIndex
      else
        IncAmount := FButtonItems.Count - FFocusIndex;
    end
  else if (Message.CharCode = VK_RETURN) or (Message.CharCode = VK_SPACE) then
    begin
      if (nboGroupStyle in ButtonOptions) and (FItemIndex <> -1) then
        DoItemClicked(FItemIndex)
      else if (nboGroupStyle in ButtonOptions) and
          (FFocusIndex >= 0) and (FFocusIndex < FButtonItems.Count) then
        DoItemClicked(FFocusIndex)
      else
        inherited;
    end
  else
    inherited;

  if IncAmount <> 0 then
    begin
      if nboGroupStyle in ButtonOptions then
        FixIncAmount(FItemIndex)
      else
        FixIncAmount(FFocusIndex);
      if IncAmount <> 0 then
        begin
          if nboGroupStyle in ButtonOptions then
            begin
              NewIndex := ItemIndex + IncAmount;
              ScrollIntoView(NewIndex);
              ItemIndex := NewIndex;
            end
          else
            begin
              NewIndex := FFocusIndex+ IncAmount;
              ScrollIntoView(NewIndex);
              UpdateButton(FFocusIndex);
              FFocusIndex := NewIndex;
              UpdateButton(FFocusIndex);
            end;
        end;
    end;
end;

constructor TQzNavigationView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 100;
  Height := 100;
  ControlStyle := [csDoubleClicks, csCaptureMouse, csDisplayDragImage, csPannable];
  FButtonItems := GetButtonsClass.Create(Self);
  FButtonOptions := [nboShowCaptions];
  FBorderStyle := bsSingle;
  FButtonHeight := 24;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FDoubleBuffered := True;
  FHotIndex := -1;
  FDownIndex := -1;
  FItemIndex := -1;
  FDragIndex := -1;
  FInsertBottom := -1;
  FInsertTop := -1;
  FDragImageList := TDragImageList.Create(nil);
  FFocusIndex := -1;
  TabStop := True;
  Touch.InteractiveGestures := [igPan, igPressAndTap];
  Touch.InteractiveGestureOptions := [igoPanInertia, igoPanSingleFingerHorizontal,
    igoPanSingleFingerVertical, igoPanGutter, igoParentPassthrough];
end;

class constructor TQzNavigationView.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TQzNavigationView, TScrollingStyleHook);
end;

function TQzNavigationView.CreateButton: TQzNavigationButtonItem;
begin
  Result := GetButtonClass.Create(FButtonItems);
end;

procedure TQzNavigationView.CreateHandle;
begin
  inherited CreateHandle;
  Resize;
end;

procedure TQzNavigationView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if (FBorderStyle = bsSingle) then
    begin
      Params.Style := Params.Style and not WS_BORDER;
      Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
    end;
  with Params do
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
end;

destructor TQzNavigationView.Destroy;
begin
  FDragImageList.Free;
  FButtonItems.Free;
  FImageChangeLink.Free;
  inherited Destroy;
end;

class destructor TQzNavigationView.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TQzNavigationView, TScrollingStyleHook);
end;

procedure TQzNavigationView.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited;
  FDragIndex := -1;
  RemoveInsertionPoints;
end;

procedure TQzNavigationView.DoFillRect(const Rect: TRect;
  ACanvas: TCanvas);
var
  LStyle: TCustomStyleServices;
begin
  LStyle := StyleServices(Self);
  if ParentBackground and LStyle.Enabled then
    LStyle.DrawParentBackground(Handle, ACanvas.Handle, nil, False, Rect)
  else
    ACanvas.FillRect(Rect);
end;

procedure TQzNavigationView.DoGesture(const EventInfo: TGestureEventInfo;
  var Handled: Boolean);
begin
  if EventInfo.GestureID = igiPan then
    begin
      Handled := True;
      if gfBegin in EventInfo.Flags then
        FPanPoint := EventInfo.Location
      else if not (gfEnd in EventInfo.Flags) then
        begin
          if (EventInfo.Location.Y - FPanPoint.Y) > 0 then
            ScrollPosChanged(scLineUp, (EventInfo.Location.Y - FPanPoint.Y))
          else
            ScrollPosChanged(scLineDown, (EventInfo.Location.Y - FPanPoint.Y));
          FPanPoint := EventInfo.Location
        end;
    end;
end;

procedure TQzNavigationView.DoHotButton;
begin
  if Assigned(FOnHotButton) then
    FOnHotButton(Self, FHotIndex);
end;

procedure TQzNavigationView.DoItemClicked(const Index: Integer);
var
  LFocusIndex: Integer;
  LButton: TQzNavigationButtonItem;
  LOnClick: TNotifyEvent;
begin
  if FButtonItems[Index] <> nil then
    begin
      LFocusIndex := FFocusIndex;
      FFocusIndex := Index;
      if FFocusIndex <> -1 then
        UpdateButton(LFocusIndex);
      LButton := TQzNavigationButtonItem(FButtonItems[Index]);
      LOnClick := LButton.OnClick;
      if Assigned(LOnClick) and (LButton.Action <> nil) and
         not DelegatesEqual(@LOnClick, @LButton.Action.OnExecute) then
        LOnClick(Self)
      else if not (csDesigning in ComponentState) and (LButton.ActionLink <> nil) then
        LButton.ActionLink.Execute(Self)
      else if Assigned(LOnClick) then
        LOnClick(Self)
      else if Assigned(FOnButtonClicked) then
        FOnButtonClicked(Self, Index);
    end
  else if Assigned(FOnButtonClicked) then
    FOnButtonClicked(Self, Index);
end;

function TQzNavigationView.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
    begin
      UpdateButton(FHotIndex);
      FHotIndex := -1;
      Result := True;
      if (FScrollBarMax > 0) and (Shift = []) then
        ScrollPosChanged(scLineDown, 0)
      else if (FScrollBarMax > 0) and (ssCtrl in Shift) then
        ScrollPosChanged(scPageDown, 0)
    end;
end;

function TQzNavigationView.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
    begin
      UpdateButton(FHotIndex);
      FHotIndex := -1;
      Result := True;
      if (FScrollBarMax > 0) and (Shift = []) then
        ScrollPosChanged(scLineUp, 0)
      else if (FScrollBarMax > 0) and (ssCtrl in Shift) then
        ScrollPosChanged(scPageUp, 0)
    end;
end;

procedure TQzNavigationView.DoReorderButton(const OldIndex,
  NewIndex: Integer);
var
  OldIndexID: Integer;
begin
  FIgnoreUpdate := True;
  try
    if FItemIndex <> -1 then
      OldIndexID := Items[FItemIndex].ID
    else
      OldIndexID := -1;
    FButtonItems.Items[OldIndex].Index := NewIndex;
    if OldIndexID <> -1 then
      FItemIndex := Items.FindItemID(OldIndexID).Index;
  finally
    FIgnoreUpdate := False;
  end;
  if HandleAllocated then
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW);
  if Assigned(FOnReorderButton) then
    FOnReorderButton(Self, OldIndex, NewIndex);
end;

procedure TQzNavigationView.DoStartDrag(var DragObject: TDragObject);
var
  ButtonRect: TRect;
  State: TButtonDrawState;
  DragImage: TBitmap;
begin
  inherited DoStartDrag(DragObject);
  if FDragIndex <> -1 then
    begin
      DragImage := TBitmap.Create;
      try
        ButtonRect := GetButtonRect(FDragIndex);
        DragImage.Width := ButtonRect.Right - ButtonRect.Left;
        DragImage.Height := ButtonRect.Bottom - ButtonRect.Top;
        State := [bdsDragged];
        if FItemIndex = FDragIndex then
          State := State + [bdsSelected];
        DrawButton(FDragIndex, DragImage.Canvas,
          Rect(0, 0, DragImage.Width, DragImage.Height), State);
        FDragImageList.Clear;
        FDragImageList.Width := DragImage.Width;
        FDragImageList.Height := DragImage.Height;
        FDragImageList.Add(DragImage, nil);
        FDragImageList.DragHotspot := TPoint.Create(FDragStartPos.X - ButtonRect.Left - Mouse.DragThreshold,
          FDragStartPos.Y - ButtonRect.Top - Mouse.DragThreshold);
      finally
        DragImage.Free;
      end;
    end
  else
    FDragImageList.Clear;
end;

procedure TQzNavigationView.DragDrop(Source: TObject; X, Y: Integer);
var
  TargetIndex: Integer;
begin
  if (Source = Self) and (nboAllowReorder in ButtonOptions) then
    begin
      RemoveInsertionPoints;
      TargetIndex := TargetIndexAt(X, Y);
      if TargetIndex > FDragIndex then
        Dec(TargetIndex);
      if TargetIndex <> -1 then
        DoReorderButton(FDragIndex, TargetIndex);
      FDragIndex := -1;
    end
  else
    inherited;
end;

procedure TQzNavigationView.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  OverIndex: Integer;
begin
  if (Source = Self) and (nboAllowReorder in ButtonOptions) then
    begin
      if (FHiddenItems < FScrollBarMax) and (Y <= Height) and
           (Y >= Height - cScrollBuffer) and (X >= 0) and (X <= Width) then
        AutoScroll(scLineDown)
      else if (FHiddenItems > 0) and (Y >= 0) and
           (Y <= cScrollBuffer) and (X >= 0) and (X <= Width) then
        AutoScroll(scLineUp);

      OverIndex := TargetIndexAt(X, Y);
      Accept := (OverIndex <> -1) and (OverIndex <> FDragIndex) and
        (OverIndex <> FDragIndex + 1) and (Items.Count > 1);
      FDragImageList.HideDragImage;
      if Accept and (State <> dsDragLeave) then
        SetInsertionPoints(OverIndex)
      else
        RemoveInsertionPoints;
      UpdateWindow(Handle);
      FDragImageList.ShowDragImage;
    end
  else
    inherited DragOver(Source, X, Y, State, Accept);
end;

procedure TQzNavigationView.DrawButton(Index: Integer; Canvas: TCanvas;
  Rect: TRect; State: TButtonDrawState);
var
  TextLeft, TextTop: Integer;
  RectHeight: Integer;
  ImgTop: Integer;
  TextOffset: Integer;
  ButtonItem: TQzNavigationButtonItem;
  FillColor: TColor;
  EdgeColor: TColor;
  InsertIndication: TRect;
  TextRect: TRect;
  OrgRect: TRect;
  Text: string;
  LColor: TColor;
  LStyle: TCustomStyleServices;
  LDetails: TThemedElementDetails;
  SaveIndex: Integer;
  TxtColor: TColor;
begin
  if Assigned(FOnDrawButton) and (not (csDesigning in ComponentState)) then
    FOnDrawButton(Self, Index, Canvas, Rect, State)
  else
    begin
      OrgRect := Rect;
      Canvas.Font := Font;

      LStyle := StyleServices(Self);
      if IsStyleEnabled then
        begin
          if (bdsSelected in State) or (bdsDown in State) then
            LDetails := LStyle.GetElementDetails(tcbButtonSelected)
          else if bdsHot in State then
            LDetails := LStyle.GetElementDetails(tcbButtonHot)
          else
            LDetails := LStyle.GetElementDetails(tcbButtonNormal);

          if not (IsCustomStyleActive and not (seFont in StyleElements)) and
             LStyle.GetElementColor(LDetails, ecTextColor, LColor) and (LColor <> clNone) then
            Canvas.Font.Color := LColor;
        end
      else
        begin
          if bdsSelected in State then
            begin
              Canvas.Brush.Color := GetShadowColor(clBtnFace, -25);
              Canvas.Font.Color := clBtnText;
            end
          else if bdsDown in State then
            begin
              Canvas.Brush.Color := clBtnShadow;
              Canvas.Font.Color := clBtnFace;
            end
          else
            Canvas.Brush.Color := clBtnFace;
        end;

      if Assigned(FOnBeforeDrawButton) then
        FOnBeforeDrawButton(Self, Index, Canvas, Rect, State);

      FillColor := Canvas.Brush.Color;
      EdgeColor := GetShadowColor(FillColor, -25);

      if IsStyleEnabled then
        begin
          InflateRect(Rect, -1, -1);
          SaveIndex := SaveDC(Canvas.Handle);
          try
            LStyle.DrawElement(Canvas.Handle, LDetails, Rect);
          finally
            RestoreDC(Canvas.Handle, SaveIndex);
          end;
        end
      else
        begin
          InflateRect(Rect, -2, -1);
          Canvas.FillRect(Rect);
        end;

      if (bdsHot in State) and not (bdsDown in State) then
        EdgeColor := GetShadowColor(EdgeColor, -50);

      if bdsSelected in State then
        begin
          FillColor := Canvas.Brush.Color;
          Canvas.Brush.Color := clHotLight;
          Canvas.Pen.Style := psClear;
          Canvas.RoundRect(Rect.Left + 4, Rect.Top + 4,
            Rect.Left + 10, Rect.Bottom - 4, 4, 4);
          Canvas.Pen.Style := psSolid;
          Canvas.Brush.Color := FillColor;
        end;

      TextLeft := Rect.Left + 14;
      RectHeight := Rect.Bottom - Rect.Top;
       TextTop := Rect.Top + (RectHeight - Canvas.TextHeight('Wg')) div 2; { Do not localize }
      if TextTop < Rect.Top then
        TextTop := Rect.Top;
      if bdsDown in State then
        begin
          Inc(TextTop);
          Inc(TextLeft);
        end;

      ButtonItem := FButtonItems[Index];
      TextOffset := 0;
      if Assigned(FOnDrawIcon) then
        FOnDrawIcon(Self, Index, Canvas, OrgRect, State, TextOffset)
      else if (FImages <> nil) and (ButtonItem.ImageIndex > -1) and
        (ButtonItem.ImageIndex < FImages.Count) then
        begin
          ImgTop := Rect.Top + (RectHeight - FImages.Height) div 2;
          if ImgTop < Rect.Top then
            ImgTop := Rect.Top;
          if bdsDown in State then
            Inc(ImgTop);
          FImages.Draw(Canvas, TextLeft - 1, ImgTop, ButtonItem.ImageIndex);
          TextOffset := FImages.Width + 1;
        end;

      if [bdsInsertLeft, bdsInsertTop, bdsInsertRight, bdsInsertBottom] * State <> [] then
        begin
          Canvas.Brush.Color := GetShadowColor(EdgeColor);
          InsertIndication := Rect;
          if bdsInsertLeft in State then
            begin
              Dec(InsertIndication.Left, 2);
              InsertIndication.Right := InsertIndication.Left + 2;
            end
          else if bdsInsertTop in State then
            begin
              Dec(InsertIndication.Top);
              InsertIndication.Bottom := InsertIndication.Top + 2;
            end
          else if bdsInsertRight in State then
            begin
              Inc(InsertIndication.Right, 2);
              InsertIndication.Left := InsertIndication.Right - 2;
            end
          else if bdsInsertBottom in State then
            begin
              Inc(InsertIndication.Bottom);
              InsertIndication.Top := InsertIndication.Bottom - 2;
            end;
          Canvas.FillRect(InsertIndication);
          Canvas.Brush.Color := FillColor;
        end;

      if nboShowCaptions in FButtonOptions then
        begin
          Inc(TextLeft, TextOffset);
          TextRect.Left := TextLeft;
          TextRect.Right := Rect.Right - 1;
          TextRect.Top := TextTop;
          TextRect.Bottom := Rect.Bottom -1;
          Text := ButtonItem.Caption;
          if IsStyleEnabled then
            begin
              Canvas.Brush.Style := bsClear;
              if (seFont in StyleElements) and LStyle.GetElementColor(LDetails, ecTextColor, TxtColor) then
                Canvas.Font.Color := TxtColor;
              Canvas.TextRect(TextRect, Text, [tfEndEllipsis]);
              Canvas.Brush.Style := bsSolid;
            end
          else
            Canvas.TextRect(TextRect, Text, [tfEndEllipsis]);
        end;

      if Assigned(FOnAfterDrawButton) then
        FOnAfterDrawButton(Self, Index, Canvas, OrgRect, State);
    end;
  Canvas.Brush.Color := Color;
end;

function TQzNavigationView.GetButtonClass: TQzNavigationButtonItemClass;
begin
  Result := TQzNavigationButtonItem;
end;

function TQzNavigationView.GetButtonRect(const Index: Integer): TRect;
begin
  Result.Top := (Index - FHiddenItems) * FButtonHeight;
  Result.Left := 0;
  Result.Right := ClientWidth;
  Result.Bottom := Result.Top + FButtonHeight;
end;

function TQzNavigationView.GetButtonsClass: TQzNavigationButtonItemsClass;
begin
  Result := TQzNavigationButtonItems;
end;

function TQzNavigationView.GetDragImages: TDragImageList;
begin
  Result := FDragImageList;
end;

procedure TQzNavigationView.ImageListChange(Sender: TObject);
begin
  CheckImageIndexes;
  UpdateAllButtons;
end;

function TQzNavigationView.IndexOfButtonAt(const X, Y: Integer): Integer;
var
  HiddenCount: Integer;
  Row: Integer;
begin
  Result := -1;
  if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    begin
      HiddenCount := FHiddenItems;
      Row := Y div FButtonHeight;
      Result := HiddenCount + Row;
      if Result >= FButtonItems.Count then
        Result := -1
      else if (Row + 1) * FButtonHeight > Height then
        Result := -1;
    end;
end;

function TQzNavigationView.IsStyleEnabled: Boolean;
begin
  Result := IsCustomStyleActive and (seClient in StyleElements);
end;

function TQzNavigationView.IsTouchPropertyStored(
  AProperty: TTouchProperty): Boolean;
begin
  Result := inherited IsTouchPropertyStored(AProperty);
  case AProperty of
    tpInteractiveGestures:
      Result := Touch.InteractiveGestures <> [igPan, igPressAndTap];
    tpInteractiveGestureOptions:
      Result := Touch.InteractiveGestureOptions <> [igoPanInertia,
        igoPanSingleFingerHorizontal, igoPanSingleFingerVertical,
        igoPanGutter, igoParentPassthrough];
  end;
end;

procedure TQzNavigationView.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
    begin
      if not Focused then
        Winapi.Windows.SetFocus(Handle);

      FDragStarted := False;
      FDownIndex := IndexOfButtonAt(X, Y);
      if FDownIndex <> -1 then
        begin
          if nboAllowReorder in ButtonOptions then
            FDragIndex := FDownIndex;
          FDragStartPos := Point(X, Y);
          if FDownIndex <> FItemIndex then
            UpdateButton(FDownIndex)
          else
            FDownIndex := -1;
        end;
    end;
end;

procedure TQzNavigationView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewHotIndex, OldHotIndex: Integer;
  EventTrack: TTrackMouseEvent;
  DragThreshold: Integer;
begin
  inherited;
  if (nboAllowReorder in ButtonOptions) and (FDragIndex <> -1) then
    begin
      DragThreshold := Mouse.DragThreshold;
      if (Abs(FDragStartPos.X - X) >= DragThreshold) or
        (Abs(FDragStartPos.Y - Y) >= DragThreshold) then
        begin
          FDragStartPos.X := X;
          FDragStartPos.Y := Y;
          FDownIndex := -1;
          if FHotIndex <> -1 then
            begin
              OldHotIndex := FHotIndex;
              FHotIndex := -1;
              UpdateButton(OldHotIndex);
              UpdateWindow(Handle);
              DoHotButton;
            end;
          FDragStarted := True;
          BeginDrag(True, -1);
          Exit;
        end;
    end;

  NewHotIndex := IndexOfButtonAt(X, Y);
  if NewHotIndex <> FHotIndex then
    begin
      OldHotIndex := FHotIndex;
      FHotIndex := NewHotIndex;
      UpdateButton(OldHotIndex);
      if FHotIndex <> -1 then
        UpdateButton(FHotIndex);
      DoHotButton;
    end;
  if not FMouseInControl then
    begin
      FMouseInControl := True;
{$IF DEFINED(CLR)}
      EventTrack.cbSize := Marshal.SizeOf(TypeOf(TTrackMouseEvent));
{$ELSE}
      EventTrack.cbSize := SizeOf(TTrackMouseEvent);
{$ENDIF}
      EventTrack.dwFlags := TME_LEAVE;
      EventTrack.hwndTrack := Handle;
      EventTrack.dwHoverTime := 0;
      TrackMouseEvent(EventTrack);
    end;
end;

procedure TQzNavigationView.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  LastDown: Integer;
begin
  inherited;
  if (Button = mbLeft) and (not FDragStarted) then
    begin
      LastDown := FDownIndex;
      FDownIndex := -1;
      FDragIndex := -1;
      if (LastDown <> -1) and (IndexOfButtonAt(X, Y) = LastDown)
        and (FDragIndex = -1) then
        begin
          UpdateButton(LastDown);
          DoItemClicked(LastDown);
          if nboGroupStyle in ButtonOptions then
            ItemIndex := LastDown;
        end
      else if LastDown <> -1 then
        UpdateButton(LastDown);
      if Assigned(FOnClick) then
        FOnClick(Self);
    end;
  FDragStarted := False;
end;

procedure TQzNavigationView.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited;
  if (Operation = opRemove) then
    begin
      if AComponent = Images then
        Images := nil
      else
        if AComponent is TBasicAction then
          for I := 0 to FButtonItems.Count - 1 do
            if AComponent = FButtonItems[I].Action then
              FButtonItems[I].Action := nil;
    end;
end;

procedure TQzNavigationView.Paint;
var
  ButtonCount: Integer;
  RowsSeen: Integer;
  HiddenCount, VisibleCount: Integer;
  CurOffset: TPoint;
  X: Integer;
  ItemRect: TRect;
  ActualWidth, ActualHeight: Integer;
  DrawState: TButtonDrawState;
  LColor: TColor;
  LStyle: TCustomStyleServices;
  LCanvas: TCanvas;
  Buffer: TBitmap;
begin
  Buffer := nil;
  try
    if not DoubleBuffered and IsCustomStyleActive and (seClient in StyleElements) then
      begin
        Buffer := TBitmap.Create;
        Buffer.SetSize(ClientWidth, ClientHeight);
        LCanvas := Buffer.Canvas;
      end
    else
        LCanvas := Canvas;

    LStyle := StyleServices(Self);
    if IsStyleEnabled and
       LStyle.GetElementColor(LStyle.GetElementDetails(tcbBackground), ecFillColor, LColor) and
       (LColor <> clNone) then
      LCanvas.Brush.Color := LColor
    else
      LCanvas.Brush.Color := clBtnFace;

    DoFillRect(Rect(0, 0, ClientWidth, ClientHeight), LCanvas);

    ButtonCount := FButtonItems.Count;
    if ButtonCount > 0 then
      begin
        RowsSeen := CalcRowsSeen;
        HiddenCount := FHiddenItems;
        VisibleCount := RowsSeen;

        if (HiddenCount + VisibleCount) > ButtonCount then
          VisibleCount := ButtonCount - HiddenCount;

        CurOffset.X := 0;
        CurOffset.Y := 0;
        ActualWidth := ClientWidth;
        ActualHeight := FButtonHeight;

        for X := HiddenCount to HiddenCount + VisibleCount - 1 do
          begin
            ItemRect := Bounds(CurOffset.X, CurOffset.Y, ActualWidth, ActualHeight);
            DrawState := [];
            if X = FHotIndex then
              begin
                Include(DrawState, bdsHot);
                if X = FDownIndex then
                  Include(DrawState, bdsDown);
              end;
            if X = FItemIndex then
              Include(DrawState, bdsSelected);

            if X = FInsertTop then
              Include(DrawState, bdsInsertTop)
            else if X = FInsertBottom then
              Include(DrawState, bdsInsertBottom);
            if (X = FFocusIndex) and Focused then
              Include(DrawState, bdsFocused);

            DrawButton(X, LCanvas, ItemRect, DrawState);
            if IsStyleEnabled and (LColor <> clNone) then
              LCanvas.Brush.Color := LColor;
            CurOffset.X := 0;
            Inc(CurOffset.Y, ActualHeight);
          end;
      end;
  finally
    if Buffer <> nil then
      begin
        Canvas.Draw(0, 0, Buffer);
        Buffer.Free;
      end;
  end;
end;

procedure TQzNavigationView.RemoveInsertionPoints;

  procedure ClearSelection(var Index: Integer);
  var
    OldIndex: Integer;
  begin
    if Index <> -1 then
      begin
        OldIndex := Index;
        Index := -1;
        UpdateButton(OldIndex);
      end;
  end;

begin
  ClearSelection(FInsertTop);
  ClearSelection(FInsertBottom);
end;

procedure TQzNavigationView.Resize;
var
  RowsSeen: Integer;
  TotalRowsNeeded: Integer;
  ScrollInfo: TScrollInfo;
begin
  inherited;
  FHiddenItems := 0;
  FScrollBarMax := 0;

  RowsSeen := CalcRowsSeen;

  if (RowsSeen < FButtonItems.Count) then
    begin
      TotalRowsNeeded := FButtonItems.Count;

      if TotalRowsNeeded > RowsSeen then
        FPageAmount := RowsSeen
      else
        FPageAmount := TotalRowsNeeded;

      FScrollBarMax := TotalRowsNeeded - FPageAmount;

{$IF DEFINED(CLR)}
      ScrollInfo.cbSize := Marshal.SizeOf(TypeOf(TScrollInfo));
{$ELSE}
      ScrollInfo.cbSize := SizeOf(TScrollInfo);
{$ENDIF}
      ScrollInfo.fMask := SIF_RANGE or SIF_POS or SIF_PAGE;
      ScrollInfo.nMin := 0;
      ScrollInfo.nMax := TotalRowsNeeded - 1;
      ScrollInfo.nPos := 0;
      ScrollInfo.nPage := FPageAmount;

      SetScrollInfo(Handle, SB_VERT, ScrollInfo, False);
      ShowScrollBar(True);
    end
  else
    ShowScrollBar(False);
end;

procedure TQzNavigationView.ScrollIntoView(const Index: Integer);
var
  RowsSeen, HiddenCount, VisibleCount: Integer;
begin
  if (Index >= 0) and (Index < FButtonItems.Count) then
  begin
    HiddenCount := FHiddenItems;
    if Index < HiddenCount then
      begin
        while (Index <= HiddenCount) and (FHiddenItems > 0) do
          begin
            ScrollPosChanged(scLineUp, 0);
            HiddenCount := FHiddenItems;
          end;
      end
    else
      begin
        RowsSeen := CalcRowsSeen;
        VisibleCount := RowsSeen;
        while Index >= (HiddenCount + VisibleCount) do
          begin
            ScrollPosChanged(scLineDown, 0);
            HiddenCount := FHiddenItems;
          end;
      end;
  end;
end;

procedure TQzNavigationView.ScrollPosChanged(ScrollCode: TScrollCode;
  ScrollPos: Integer);
var
  OldPos: Integer;
begin
  OldPos := FHiddenItems;
  if (ScrollCode = scLineUp) and (FHiddenItems > 0) then
    Dec(FHiddenItems)
  else if (ScrollCode = scLineDown) and (FHiddenItems < FScrollBarMax) then
    Inc(FHiddenItems)
  else if (ScrollCode = scPageUp) then
    begin
      Dec(FHiddenItems, FPageAmount);
      if FHiddenItems < 0 then
        FHiddenItems := 0;
    end
  else if ScrollCode = scPageDown then
    begin
      Inc(FHiddenItems, FPageAmount);
      if FHiddenItems > FScrollBarMax then
        FHiddenItems := FScrollBarMax;
    end
  else if ScrollCode in [scPosition, scTrack] then
    FHiddenItems := ScrollPos
  else if ScrollCode = scTop then
    FHiddenItems := 0
  else if ScrollCode = scBottom then
    FHiddenItems := FScrollBarMax;
  if OldPos <> FHiddenItems then
    begin
      SetScrollPos(Handle, cScrollBarKind, FHiddenItems, True);
      RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW);
    end;
end;

procedure TQzNavigationView.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
    begin
      FBorderStyle := Value;
      RecreateWnd;
    end;
end;

procedure TQzNavigationView.SetButtonHeight(const Value: Integer);
begin
  if (FButtonHeight <> Value) and (Value > 0) then
    begin
      FButtonHeight := Value;
      UpdateAllButtons;
    end;
end;

procedure TQzNavigationView.SetButtonItems(
  const Value: TQzNavigationButtonItems);
begin
  FButtonItems.Assign(Value);
end;

procedure TQzNavigationView.SetButtonOptions(
  const Value: TQzNavigationButtonOptions);
begin
  if FButtonOptions <> Value then
    begin
      FButtonOptions := Value;
      if not (nboGroupStyle in FButtonOptions) then
        FItemIndex := -1;
      if HandleAllocated then
        begin
          Resize;
          UpdateAllButtons;
        end;
  end;
end;

procedure TQzNavigationView.SetDragIndex(const Value: Integer);
begin
  FDragIndex := Value;
  FDragStarted := True;
end;

procedure TQzNavigationView.SetImages(const Value: TCustomImageList);
begin
  if Images <> Value then
    begin
      if Images <> nil then
        Images.UnRegisterChanges(FImageChangeLink);
      FImages := Value;
      if Images <> nil then
        begin
          Images.RegisterChanges(FImageChangeLink);
          Images.FreeNotification(Self);
       end;
     UpdateAllButtons;
    end;
end;

procedure TQzNavigationView.SetInsertionPoints(
  const InsertionIndex: Integer);
begin
  if FInsertTop <> InsertionIndex then
    begin
      RemoveInsertionPoints;

      FInsertTop := InsertionIndex;
      FInsertBottom := InsertionIndex - 1;

      UpdateButton(FInsertTop);

      UpdateWindow(Handle);
    end;
end;

procedure TQzNavigationView.SetItemIndex(const Value: Integer);
var
  OldIndex: Integer;
begin
  if (FItemIndex <> Value) and (nboGroupStyle in ButtonOptions) then
    begin
      OldIndex := FItemIndex;
      FItemIndex := Value;
      FFocusIndex := Value;
      UpdateButton(OldIndex);
      UpdateButton(FItemIndex);
    end;
end;

procedure TQzNavigationView.SetOnDrawButton(
  const Value: TQzNavigationButtonDrawEvent);
begin
  FOnDrawButton := Value;
  Invalidate;
end;

procedure TQzNavigationView.SetOnDrawIcon(
  const Value: TQzNavigationButtonDrawIconEvent);
begin
  FOnDrawIcon := Value;
  Invalidate;
end;

procedure TQzNavigationView.ShowScrollBar(const Visible: Boolean);
begin
  if Visible <> FScrollBarShown then
    begin
      FScrollBarShown := Visible;
      Winapi.Windows.ShowScrollBar(Handle, cScrollBarKind, Visible);
    end;
end;

function TQzNavigationView.TargetIndexAt(const X, Y: Integer): Integer;
var
  ButtonRect: TRect;
  LastRect: TRect;
begin
  Result := IndexOfButtonAt(X, Y);
  if Result = -1 then
    begin
      LastRect := GetButtonRect(Items.Count);
      if (Y >= LastRect.Bottom) then
        Result := Items.Count
      else if (Y >= LastRect.Top) then
        Result := Items.Count;
    end;
  if (Result > -1) and (Result < Items.Count) then
    begin
      ButtonRect := GetButtonRect(Result);
      if Y > (ButtonRect.Top + (ButtonRect.Bottom - ButtonRect.Top) div 2) then
        Inc(Result);
    end;
end;

procedure TQzNavigationView.UpdateAllButtons;
begin
  if HandleAllocated then
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW);
end;

procedure TQzNavigationView.UpdateButton(const Index: Integer);
var
  R: TRect;
begin
  if Index >= 0 then
    begin
      R := GetButtonRect(Index);
      InvalidateRect(Handle, R, False);
    end;
end;

procedure TQzNavigationView.WMHScroll(var Message: TWMHScroll);
begin
  ScrollPosChanged(TScrollCode(Message.ScrollCode), Message.Pos);
end;

procedure TQzNavigationView.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  UpdateButton(FFocusIndex)
end;

procedure TQzNavigationView.WMMouseLeave(var Message: TMessage);
begin
  FMouseInControl := False;
  if FHotIndex <> -1 then
    begin
      UpdateButton(FHotIndex);
      FHotIndex := -1;
      DoHotButton;
    end;
  if FDragImageList.Dragging then
    begin
      FDragImageList.HideDragImage;
      RemoveInsertionPoints;
      UpdateWindow(Handle);
      FDragImageList.ShowDragImage;
    end;
end;

procedure TQzNavigationView.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if (FFocusIndex = -1) and (FButtonItems.Count > 0)  then
    FFocusIndex := 0;
  UpdateButton(FFocusIndex)
end;

procedure TQzNavigationView.WMSize(var Message: TWMSize);
begin
  inherited;
  RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW);
end;

procedure TQzNavigationView.WMVScroll(var Message: TWMVScroll);
begin
  ScrollPosChanged(TScrollCode(Message.ScrollCode), Message.Pos);
end;

{ TQzNavigationButtonItem }

procedure TQzNavigationButtonItem.CheckImageIndexAndName;
var
  LImages: TCustomImageList;
begin
  if NavigationView <> nil then
    LImages := NavigationView.Images
  else
    LImages := nil;
  if (LImages <> nil) and LImages.IsImageNameAvailable then
    LImages.CheckIndexAndName(FImageIndex, FImageName);
end;

function TQzNavigationButtonItem.GetCollection: TQzNavigationButtonItems;
begin
  Result := TQzNavigationButtonItems(inherited Collection);
end;

function TQzNavigationButtonItem.GetNavigationView: TQzNavigationView;
begin
  Result := Collection.NavigationView;
end;

function TQzNavigationButtonItem.GetNotifyTarget: TComponent;
begin
  Result := TComponent(NavigationView);
end;

procedure TQzNavigationButtonItem.ScrollIntoView;
begin
  TQzNavigationButtonItems(Collection).FNavigationView.ScrollIntoView(Index);
end;

procedure TQzNavigationButtonItem.SetCollection(
  const Value: TQzNavigationButtonItems);
begin
  inherited Collection := Value;
end;

{ TQzNavigationButtonItems }

function TQzNavigationButtonItems.Add: TQzNavigationButtonItem;
begin
  Result := TQzNavigationButtonItem(inherited Add);
end;

function TQzNavigationButtonItems.AddItem(Item: TQzNavigationButtonItem;
  Index: Integer): TQzNavigationButtonItem;
begin
  if (Item = nil) and (FNavigationView <> nil) then
    Result := FNavigationView.CreateButton
  else
    Result := Item;
  if Assigned(Result) then
    begin
      Result.Collection := Self;
      if Index < 0 then
        Index := Count - 1;
      Result.Index := Index;
    end;
end;

procedure TQzNavigationButtonItems.BeginUpdate;
begin
  if UpdateCount = 0 then
    if FNavigationView.ItemIndex <> -1 then
      FOriginalID := Items[FNavigationView.ItemIndex].ID
    else
      FOriginalID := -1;
  inherited;
end;

constructor TQzNavigationButtonItems.Create(
  const NavigationView: TQzNavigationView);
begin
  if NavigationView <> nil then
    inherited Create(NavigationView.GetButtonClass)
  else
    inherited Create(TQzNavigationButtonItem);
  FNavigationView := NavigationView;
  FOriginalID := -1;
end;

function TQzNavigationButtonItems.GetItem(
  Index: Integer): TQzNavigationButtonItem;
begin
  Result := TQzNavigationButtonItem(inherited GetItem(Index));
end;

function TQzNavigationButtonItems.GetOwner: TPersistent;
begin
  Result := FNavigationView;
end;

function TQzNavigationButtonItems.Insert(
  Index: Integer): TQzNavigationButtonItem;
begin
  Result := AddItem(nil, Index);
end;

procedure TQzNavigationButtonItems.SetItem(Index: Integer;
  const Value: TQzNavigationButtonItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TQzNavigationButtonItems.Update(Item: TCollectionItem);
var
  AItem: TCollectionItem;
begin
  if (UpdateCount = 0) and (not FNavigationView.FIgnoreUpdate) then
    begin
      if Item <> nil then
        FNavigationView.UpdateButton(Item.Index)
      else
        begin
          if (FOriginalID <> -1) then
            AItem := FindItemID(FOriginalID)
          else
            AItem := nil;
          if AItem = nil then
            begin
              FNavigationView.FItemIndex := -1;
              FNavigationView.FFocusIndex := -1;
            end
          else if nboGroupStyle in FNavigationView.ButtonOptions then
            FNavigationView.FItemIndex := AItem.Index;
          FNavigationView.Resize;
          FNavigationView.UpdateAllButtons;
        end;
    end;
end;

end.
