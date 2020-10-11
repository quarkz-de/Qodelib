unit Qodelib.Themes;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  Vcl.Themes;

type
  TQuarkzThemeType = (qttUnknown, qttWindows, qttQuarkzDarkBlue,
    qttQuarkzDarkOrange);

  TQuarkzThemeManager = class
  private
    FTheme: TQuarkzThemeType;
    procedure SetTheme(const Value: TQuarkzThemeType);
    function GetIsDark: Boolean;
    procedure SetThemeName(const Value: String);
    function GetThemeName: String;
  public
    constructor Create;
    property Theme: TQuarkzThemeType read FTheme write SetTheme;
    property IsDark: Boolean read GetIsDark;
    property ThemeName: String read GetThemeName write SetThemeName;
  end;

var
  QuarkzThemeManager: TQuarkzThemeManager;

implementation

{$R *.res}

const
  ThemeNames: array[TQuarkzThemeType] of String = ('Windows', 'Windows',
    'quarkzDarkBlue', 'quarkzDarkOrange');

{ TQuarkzThemeManager }

constructor TQuarkzThemeManager.Create;
begin
  inherited Create;
  FTheme := qttUnknown;
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

initialization
  QuarkzThemeManager := TQuarkzThemeManager.Create;
finalization
  FreeAndNil(QuarkzThemeManager);
end.
