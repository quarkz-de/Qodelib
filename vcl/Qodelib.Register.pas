unit Qodelib.Register;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Math, System.UITypes,
  Vcl.Graphics, Vcl.ImgList;

{$IFDEF WIN32}
procedure Register;
{$ENDIF}

implementation

{$IFDEF WIN32}
uses
  DesignIntf, DesignEditors, VCLEditors,
  Qodelib.NavigationView,
  Qodelib.Panels;
{$ENDIF}

{$IFDEF WIN32}

type
  TQzCustomImageIndexProperty = class(TIntegerProperty, ICustomPropertyListDrawing)
  protected
    function GetImageList: TCustomImageList; virtual; abstract;
    function GetImageHeight(Images: TCustomImageList; ACanvas: TCanvas): Integer; virtual;
    function GetImageWidth(Images: TCustomImageList; ACanvas: TCanvas): Integer; virtual;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean);
  end;

  TQzNavigationButtonItemImageIndexProperty = class(TQzCustomImageIndexProperty)
  protected
    function GetImageList: TCustomImageList; override;
  end;

{ TQzCustomImageIndexProperty }

function TQzCustomImageIndexProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList, paDialog ] -
    [paSortList, paMultiSelect, paAutoUpdate, paSubProperties, paReadOnly];
end;

procedure TQzCustomImageIndexProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Images: TCustomImageList;
begin
  Images := GetImageList;
  if Images <> nil then
    begin
      for I := 0 to Images.Count - 1 do
        Proc(IntToStr(I));
    end;
end;

function TQzCustomImageIndexProperty.GetImageHeight( Images: TCustomImageList;
  ACanvas: TCanvas ): Integer;
begin
  Result := Min(Max(ACanvas.TextHeight('Wg'), Images.Height), 50);
end;

function TQzCustomImageIndexProperty.GetImageWidth(Images: TCustomImageList;
  ACanvas: TCanvas): Integer;
var
  H: Integer;
begin
  H := GetImageHeight(Images, ACanvas);
  if H < Images.Height then
    Result := Round(Images.Width * (H / Images.Height))
  else
    Result := Images.Width;
end;

procedure TQzCustomImageIndexProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
var
  Images: TCustomImageList;
begin
  Images := GetImageList;
  if Images <> nil then
    AHeight := Max(ACanvas.TextHeight('Wg'), Images.Height + 4);
end;

procedure TQzCustomImageIndexProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
var
  Images: TCustomImageList;
begin
  Images := GetImageList;
  if Images <> nil then
    AWidth := AWidth + Images.Width + 4;
end;

procedure TQzCustomImageIndexProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  R: TRect;
  Images: TCustomImageList;
begin
  R := ARect;
  R.Right := R.Left + (R.Bottom - R.Top);
  try
    ACanvas.FillRect( R );
    Images := GetImageList;
    if Images <> nil then
      Images.Draw(ACanvas, R.Left + 2, R.Top + 2, StrToInt(Value), True);
  finally
    DefaultPropertyListDrawValue(Value, ACanvas,
      Rect(R.Right, ARect.Top, ARect.Right, ARect.Bottom), ASelected);
  end;
end;

{ TQzNavigationButtonItemImageIndexProperty }

function TQzNavigationButtonItemImageIndexProperty.GetImageList: TCustomImageList;
begin
  Result := (GetComponent(0) as TQzNavigationButtonItem).NavigationView.Images;
end;

{ Register }

procedure Register;
const
  SQomponents = 'Qomponents';
begin
  RegisterComponents(SQomponents, [TQzNavigationView, TQzPanel]);

  RegisterPropertyEditor(TypeInfo(System.UITypes.TImageIndex), TQzNavigationButtonItem, 'ImageIndex',
    TQzNavigationButtonItemImageIndexProperty);
end;
{$ENDIF}

end.
