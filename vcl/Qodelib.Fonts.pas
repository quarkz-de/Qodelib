unit Qodelib.Fonts;

interface

uses
  Winapi.Windows,
  System.Classes;

type
  TFontNames = class
  public
    class procedure GetFixedPitchFonts(const AStrings: TStrings);
  end;

implementation

function EnumFixedFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
var
  Strings: TStrings;
  Fontname: String;
begin
  Strings := TStrings(Data);
  if Strings = nil then
    Result := 0
  else
    begin
      Fontname := String(LogFont.lfFaceName);
      if (LogFont.lfPitchAndFamily and FIXED_PITCH > 0) and
        (Copy(Fontname, 1, 1) <> '@') then
        Strings.Add(Fontname);
      Result := 1;
    end;
end;

{ TFontNames }

class procedure TFontNames.GetFixedPitchFonts(const AStrings: TStrings);
var
  DC: HDC;
  Proc: TFarProc;
  Fontnames: TStringList;
begin
  Fontnames := TStringList.Create;
  Fontnames.Sorted := true;
  Fontnames.Duplicates := dupIgnore;
  DC := GetDC(0);
  try
    Proc := @EnumFixedFontsProc;
    EnumFonts(DC, nil, Proc, Pointer(Fontnames));
    AStrings.Assign(Fontnames);
  finally
    ReleaseDC(0, DC);
    Fontnames.Free;
  end;
end;

end.