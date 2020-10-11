unit Qodelib.Themes;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes,
  Vcl.Themes;

type
  TQuarkzThemeType = (qttWindows, qttQuarkzDarkBlue, qttQuarkzDarkOrange);

  TQuarkzThemeManager = class
  private
    FTheme: TQuarkzThemeType;
    FOnChange: TNotifyEvent;
    procedure SetTheme(const Value: TQuarkzThemeType);
    function GetIsDark: Boolean;
    procedure SetThemeName(const Value: String);
    function GetThemeName: String;
    procedure ThemeChanged;
  public
    constructor Create;
    property Theme: TQuarkzThemeType read FTheme write SetTheme;
    property IsDark: Boolean read GetIsDark;
    property ThemeName: String read GetThemeName write SetThemeName;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    procedure AssignThemeNames(const AStrings: TStrings);
  end;

  TQuarkzThemeChangeEvent = class(TObject)
  private
    FTheme: TQuarkzThemeType;
    procedure SetTheme(const Value: TQuarkzThemeType);
  public
    constructor Create(const ATheme: TQuarkzThemeType);
    property Theme: TQuarkzThemeType read FTheme write SetTheme;
  end;

var
  QuarkzThemeManager: TQuarkzThemeManager;

implementation

{$R *.res}

const
  ThemeNames: array[TQuarkzThemeType] of String = ('Windows',
    'quarkzDarkBlue', 'quarkzDarkOrange');

{ TQuarkzThemeManager }

procedure TQuarkzThemeManager.AssignThemeNames(const AStrings: TStrings);
var
  T: TQuarkzThemeType;
begin
  AStrings.Clear;
  for T := Low(TQuarkzThemeType) to High(TQuarkzThemeType) do
    AStrings.Add(ThemeNames[T]);
end;

constructor TQuarkzThemeManager.Create;
begin
  inherited Create;
  FTheme := qttWindows;
  TStyleManager.LoadFromResource(hInstance, 'quarkzDarkOrange', RT_RCDATA);
  TStyleManager.LoadFromResource(hInstance, 'quarkzDarkBlue', RT_RCDATA);
end;

function TQuarkzThemeManager.GetIsDark: Boolean;
begin
  Result := FTheme in [qttQuarkzDarkBlue, qttQuarkzDarkOrange];
end;

function TQuarkzThemeManager.GetThemeName: String;
begin
  Result := ThemeNames[FTheme];
end;

procedure TQuarkzThemeManager.SetTheme(const Value: TQuarkzThemeType);
begin
  if FTheme <> Value then
    begin
      FTheme := Value;
      TStyleManager.TrySetStyle(ThemeName);
      ThemeChanged;
    end;
end;

procedure TQuarkzThemeManager.SetThemeName(const Value: String);
var
  T: TQuarkzThemeType;
begin
  for T := Low(TQuarkzThemeType) to High(TQuarkzThemeType) do
    begin
      if SameText(Value, ThemeNames[T]) then
        begin
          Theme := T;
          Break;
        end;
    end;
end;

procedure TQuarkzThemeManager.ThemeChanged;
begin
  if Assigned(FOnChange) then
    OnChange(self);
end;

{ TQuarkzThemeChangeEvent }

constructor TQuarkzThemeChangeEvent.Create(const ATheme: TQuarkzThemeType);
begin
  inherited Create;
  FTheme := ATheme;
end;

procedure TQuarkzThemeChangeEvent.SetTheme(const Value: TQuarkzThemeType);
begin
  FTheme := Value;
end;

initialization
  QuarkzThemeManager := TQuarkzThemeManager.Create;
finalization
  FreeAndNil(QuarkzThemeManager);
end.
